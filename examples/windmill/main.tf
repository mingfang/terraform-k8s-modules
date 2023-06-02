resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  storage_class = "cephfs"
  storage       = "1Gi"

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

module "windmill-server" {
  source    = "../../modules/windmill/server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    DATABASE_URL         = "postgres://postgres:postgres@${module.postgres.name}/postgres?sslmode=disable"
    BASE_URL             = "https://windmill-example.rebelsoft.com"
    RUST_LOG             = "info"
    ## You can set the number of workers to > 0 and not need any separate worker service
    NUM_WORKERS          = "0"
    DISABLE_SERVER       = "false"
    METRICS_ADDR         = "false"
    OAUTH_JSON_AS_BASE64 = base64encode(file("${path.module}/oauth.json"))
  }
}

module "windmill-worker" {
  source    = "../../modules/windmill/worker"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 2

  sidecars = [
    {
      name  = "dind"
      image = "docker:24.0.2-dind"
      args  = ["--insecure-registry=0.0.0.0/0"]
      env   = [
        {
          name       = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        }
      ]
      security_context = {
        privileged = true
      }
      volume_mounts = [
        {
          name       = "shared"
          mount_path = "/var/run"
        }
      ]
    }
  ]

  extra_volumes = [
    {
      volume = {
        name      = "shared"
        empty_dir = { "" = "" }
      }
      mount = {
        name       = "shared"
        mount_path = "/var/run"
      }
    }
  ]

  env_map = {
    DATABASE_URL      = "postgres://postgres:postgres@${module.postgres.name}/postgres?sslmode=disable"
    BASE_URL          = "https://windmill-example.rebelsoft.com"
    BASE_INTERNAL_URL = "http://${module.windmill-server.name}:${module.windmill-server.ports.0.port}"
    RUST_LOG          = "info"
    NUM_WORKERS       = "1"
    DISABLE_SERVER    = "true"
    KEEP_JOB_DIR      = "false"
    METRICS_ADDR      = "false"
  }
}

module "windmill-lsp" {
  source    = "../../modules/windmill/lsp"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.windmill-server.name
            service_port = module.windmill-server.ports[0].port
          }
          path = "/"
        }
        paths {
          backend {
            service_name = module.windmill-lsp.name
            service_port = module.windmill-lsp.ports[0].port
          }
          path = "/ws"
        }
      }
    }
  }
}
