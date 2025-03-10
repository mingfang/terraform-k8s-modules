module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:16"

  args = [
    "-c", "work_mem=256MB",
    "-c", "maintenance_work_mem=256MB",
    "-c", "max_wal_size=1GB",
    "-c", "wal_level=logical",
  ]
  env_map = {
    POSTGRES_DB       = "postgres"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }

  storage = "1Gi"
}

resource "k8s_core_v1_persistent_volume_claim" "storage" {
  metadata {
    name      = "storage"
    namespace = module.namespace.name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
  }
}

resource "k8s_core_v1_persistent_volume_claim" "kestra-wd" {
  metadata {
    name      = "kestra-wd"
    namespace = module.namespace.name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
  }
}

locals {
  image                = "kestra/kestra:latest-full"
  KESTRA_CONFIGURATION = <<-EOF
    datasources:
      postgres:
        url: jdbc:postgresql://${module.postgres.name}:5432/postgres
        driverClassName: org.postgresql.Driver
        username: postgres
        password: postgres
    kestra:
      server:
        basic-auth:
          enabled: false
          username: "admin@kestra.io" # it must be a valid email address
          password: kestra
      repository:
        type: postgres
      storage:
        type: local
        local:
          base-path: "/app/storage"
      queue:
        type: postgres
      tasks:
        tmp-dir:
          path: /tmp/kestra-wd/tmp
      url: http://localhost:8080/
  EOF
}

module "kestra" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = local.image

  ports = [{ name = "tcp", port = 8080 }]
  args  = ["server", "standalone", "--worker-thread=0"]
  env_map = {
    KESTRA_CONFIGURATION = local.KESTRA_CONFIGURATION
  }

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.storage.metadata[0].name
      mount_path = "/app/storage"
    },
    {
      name       = k8s_core_v1_persistent_volume_claim.kestra-wd.metadata[0].name
      mount_path = "/tmp/kestra-wd"
    },
  ]
}

module "kestra-worker" {
  source       = "../../modules/generic-deployment-service"
  name         = "kestra-worker"
  namespace    = module.namespace.name
  max_replicas = 3

  image = local.image
  args  = ["server", "worker"]
  env_map = {
    DOCKER_HOST          = "unix:///dind/docker.sock"
    KESTRA_CONFIGURATION = local.KESTRA_CONFIGURATION
  }

  sidecars = [
    {
      name  = "dind"
      image = "docker:dind-rootless"
      args  = ["--group=1000", "--log-level=fatal"]
      env = [
        {
          name = "POD_NAME"
          value_from = {
            field_ref = {
              field_path = "metadata.name"
            }
          }
        },
        {
          name  = "DOCKER_TLS_CERTDIR"
          value = ""
        },
        {
          name  = "DOCKER_HOST"
          value = "unix:///dind/docker.sock"
        }
      ]
      security_context = {
        privileged  = true
        run_asuser  = 1000
        run_asgroup = 1000
      }

      volume_mounts = [
        {
          name       = k8s_core_v1_persistent_volume_claim.kestra-wd.metadata[0].name
          mount_path = "/tmp/kestra-wd"
        },
        {
          name       = "docker-sock"
          mount_path = "/dind"
        },
      ]
    }
  ]

  pvcs = [
    {
      name       = k8s_core_v1_persistent_volume_claim.storage.metadata[0].name
      mount_path = "/app/storage"
    },
    {
      name       = k8s_core_v1_persistent_volume_claim.kestra-wd.metadata[0].name
      mount_path = "/tmp/kestra-wd"
    },
  ]

  volumes = [
    {
      name = "docker-sock"
      empty_dir = {
        medium    = "Memory"
        sizeLimit = "1G"
      }
      mount_path = "/dind"
    },
  ]

  cluster_role_rules = [
    {
      api_groups = [""]
      resources  = ["namespaces", "pods"]
      verbs      = ["get", "list", "watch", "create", "delete"]
    },
    {
      api_groups = [""]
      resources  = ["pods/log"]
      verbs      = ["get"]
    }
  ]
}

resource "k8s_networking_k8s_io_v1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.kestra.name
              port {
                number = module.kestra.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
