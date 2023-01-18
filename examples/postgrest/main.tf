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
  image     = "postgres:15.1"

  storage_class = "cephfs"
  storage       = "1Gi"

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

module "postgres_init_config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "postgres-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/config"
}

module "postgres_init" {
  source    = "../../modules/kubernetes/job"
  name      = "postgres-init"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "postgres:15.1"

  env_map = {
    PGHOST            = module.postgres.name
    PGUSER            = "postgres"
    PGPASSWORD        = "postgres"
    PGDATABASE        = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }
  configmap = module.postgres_init_config.config_map

  command = [
    "bash",
    "-c",
    <<-EOF
    until pg_isready; do
      echo 'Waiting to start...'
      sleep 5
    done

    cd /config
    shopt -s nullglob
    for sql in {0,9}*.sql; do
        echo "$0: running $sql"
        psql -v ON_ERROR_STOP=0 -f "$sql"
    done
    EOF
  ]
}

/* PostgREST */

module "postgrest" {
  source    = "../../modules/postgrest"
  name      = "postgrest"
  namespace = k8s_core_v1_namespace.this.metadata.0.name

  env_map = {
    PGRST_DB_URI                   = "postgres://authenticator:postgres@${module.postgres.name}.${var.namespace}.svc.cluster.local:${module.postgres.ports.0.port}/postgres?sslmode=disable"
    PGRST_DB_SCHEMAS               = "public"
    PGRST_DB_ANON_ROLE             = "anon"
    PGRST_DB_CHANNEL_ENABLED       = "true"
    PGRST_DB_PLAN_ENABLED          = "true"
    PGRST_DB_POOL                  = "10"
    PGRST_OPENAPI_SERVER_PROXY_URI = "https://${var.namespace}.rebelsoft.com"
    PGRST_OPENAPI_SECURITY_ACTIVE  = "true"
    PGRST_DB_USE_LEGACY_GUCS       = "false"
    PGRST_LOG_LEVEL                = "info"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "postgrest" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                   = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"      = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/proxy-buffer-size" = "160k"
      "nginx.ingress.kubernetes.io/proxy-body-size"   = "10240m"

      "nginx.ingress.kubernetes.io/enable-cors"        = "true"
      "nginx.ingress.kubernetes.io/cors-allow-headers" = "keep-alive,user-agent,x-requested-with,x-request-id,if-modified-since,cache-control,content-type,range,authorization,apikey,x-client-info,accept-profile,prefer,content-profile,range-unit,x-upsert"
      "nginx.ingress.kubernetes.io/cors-allow-origin"  = "https://*.rebelsoft.com"
    }
    name      = var.namespace
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.postgrest.name
            service_port = module.postgrest.ports.0.port
          }
          path = "/"
        }
      }
    }
  }
}
resource "k8s_networking_k8s_io_v1beta1_ingress" "postgrest_admin" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                   = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"      = "${var.namespace}-admin.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
    }
    name      = "${var.namespace}-admin"
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = "${var.namespace}-admin"
      http {
        paths {
          backend {
            service_name = module.postgrest.name
            service_port = module.postgrest.ports.1.port
          }
          path = "/"
        }
      }
    }
  }
}

module "swagger_ui" {
  source    = "../../modules/swagger-ui"
  name      = "swagger-ui"
  namespace = k8s_core_v1_namespace.this.metadata.0.name

  env_map = {
    URL = "https://${var.namespace}.rebelsoft.com"
  }
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "swagger_ui" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${module.swagger_ui.name}-${var.namespace}.*"
    }
    name      = module.swagger_ui.name
    namespace = k8s_core_v1_namespace.this.metadata.0.name
  }
  spec {
    rules {
      host = "${module.swagger_ui.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.swagger_ui.name
            service_port = module.swagger_ui.ports.0.port
          }
          path = "/"
        }
      }
    }
  }
}
