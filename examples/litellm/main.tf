module "namespace" {
  source    = "../namespace"
  name      = var.namespace
  is_create = var.is_create_namespace
}

# LiteLLM proxy — routes to multiple vLLM backends
module "litellm" {
  source    = "../../modules/generic-deployment-service"
  name      = "litellm"
  namespace = module.namespace.name
  image     = "ghcr.io/berriai/litellm:main-stable"

  ports_map = { http = 4000 }

  args = ["--config", "/config/config.yaml", "--detailed_debug"]

  env_map = {
    DATABASE_URL      = "postgresql://postgres:postgres@postgres:5432/postgres"
    LITELLM_LOG       = "INFO"
    LITELLM_MASTER_KEY = "sk-1234"
    PROXY_ADMIN_ID    = "admin"
    UI_PASSWORD       = "admin"
    UI_USERNAME       = "admin"
  }

  config_files = ["config.yaml"]
}

# Chat UI — web interface pointing to litellm
module "chat_ui" {
  source    = "../../modules/generic-deployment-service"
  name      = "chat-ui"
  namespace = module.namespace.name
  image     = "blrchen/chatgpt-lite"

  ports_map = { http = 3000 }

  env_map = {
    OPENAI_API_BASE_URL = "https://litellm-example.rebelsoft.com"
    OPENAI_API_KEY      = "sk-1234"
    OPENAI_MODEL        = "default"
  }
}

# PostgreSQL — stateful backend for LiteLLM
module "postgres" {
  source    = "../../modules/generic-statefulset-service"
  name      = "postgres"
  namespace = module.namespace.name
  image     = "postgres:17"

  ports_map = { tcp = 5432 }

  env_map = {
    POSTGRES_DB       = "postgres"
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
  }

  storage    = "100Gi"
  mount_path = "/var/lib/postgresql/data"
}

# Ingress — LiteLLM proxy
resource "k8s_networking_k8s_io_v1_ingress" "litellm" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"      = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
    }
    name      = var.namespace
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.litellm.name
              port {
                number = module.litellm.ports_map.http
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

# Ingress — Chat UI
resource "k8s_networking_k8s_io_v1_ingress" "chat_ui" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/server-alias"      = "chat-${var.namespace}.*"
      "nginx.ingress.kubernetes.io/ssl-redirect"      = "true"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "10240m"
    }
    name      = "chat-${var.namespace}"
    namespace = module.namespace.name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = "chat-${var.namespace}"
      http {
        paths {
          backend {
            service {
              name = module.chat_ui.name
              port {
                number = module.chat_ui.ports_map.http
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
