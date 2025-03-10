module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# When KONG_DATABASE="postgres"
module "postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:17"
  ports     = [{ name = "tcp", port = 5432 }]
  storage   = "1Gi"

  env_map = {
    POSTGRES_DB       = "postgres"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }
}

# When KONG_DATABASE="off"
module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = var.name
  namespace = module.namespace.name

  from-dir = "${path.module}/config"
}

module "kong" {
  source    = "../../modules/generic-deployment-service"
  name      = var.name
  namespace = module.namespace.name
  image     = "kong:latest"
  ports = [
    { name = "http", port = 8000 },
    { name = "admin", port = 8001 },
    { name = "ui", port = 8002 },
  ]

  configmap            = module.config.config_map
  configmap_mount_path = "/opt/kong"

  env_map = {
    KONG_DATABASE    = "postgres"
    KONG_PG_HOST     = module.postgres.name
    KONG_PG_DATABASE = "postgres"
    KONG_PG_USER     = "postgres"
    KONG_PG_PASSWORD = "postgres"

    KONG_PROXY_LISTEN     = "0.0.0.0:8000"
    KONG_ADMIN_LISTEN     = "0.0.0.0:8001"
    KONG_ADMIN_GUI_LISTEN = "0.0.0.0:8002"

    KONG_PROXY_ACCESS_LOG = "/dev/stdout"
    KONG_PROXY_ERROR_LOG  = "/dev/stderr"
    KONG_ADMIN_ACCESS_LOG = "/dev/stdout"
    KONG_ADMIN_ERROR_LOG  = "/dev/stderr"

    # When KONG_DATABASE="off"
    KONG_DECLARATIVE_CONFIG = "/opt/kong/kong.yaml"

    # Change
    KONG_ADMIN_GUI_API_URL = "https://admin-${var.namespace}.rebelsoft.com"

    # tracing
    KONG_TRACING_INSTRUMENTATIONS = "all"
  }

  # When KONG_DATABASE="postgres"
  init_containers = [
    {
      name  = "db-setup"
      image = "kong:latest"
      command = ["sh", "-c", <<-EOF
        kong migrations bootstrap
        kong migrations up
        kong migrations finish
        EOF
      ]
      env = [
        { name = "KONG_PG_HOST", value = module.postgres.name },
        { name = "KONG_DATABASE", value = "postgres" },
        { name = "KONG_PG_DATABASE", value = "postgres" },
        { name = "KONG_PG_USER", value = "postgres" },
        { name = "KONG_PG_PASSWORD", value = "postgres" },
      ]
    }
  ]
}

# When KONG_DATABASE="postgres"
module "deck" {
  source    = "../../modules/kubernetes/job"
  name      = "deck"
  namespace = module.namespace.name
  image     = "kong/deck:latest"

  configmap = module.config.config_map

  command = ["sh", "-c", <<-EOF
    deck gateway sync --verbose 1 /config/kong.yaml
    EOF
  ]

  env_map = {
    DECK_KONG_ADDR = "http://${module.kong.name}:${module.kong.ports.1.port}"
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "kong" {
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
              name = module.kong.name
              port {
                number = module.kong.ports.0.port
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

resource "k8s_networking_k8s_io_v1_ingress" "admin" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "admin-${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "admin-${var.namespace}"
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = "admin-${var.namespace}"
      http {
        paths {
          backend {
            service {
              name = module.kong.name
              port {
                number = module.kong.ports.1.port
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

resource "k8s_networking_k8s_io_v1_ingress" "ui" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "ui-${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "ui-${var.namespace}"
    namespace = module.namespace.name
  }
  spec {
    rules {
      host = "ui-${var.namespace}"
      http {
        paths {
          backend {
            service {
              name = module.kong.name
              port {
                number = module.kong.ports.2.port
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
