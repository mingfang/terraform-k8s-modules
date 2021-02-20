resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = var.storage_class_name
  storage       = "1Gi"

  POSTGRES_USER     = "baserow"
  POSTGRES_PASSWORD = "baserow"
  POSTGRES_DB       = "baserow"
}

module "backend" {
  source    = "../../modules/baserow/backend"
  name      = "baserow-backend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  REDIS_HOST        = module.redis.name
  DATABASE_HOST     = module.postgres.name
  DATABASE_NAME     = "baserow"
  DATABASE_USER     = "baserow"
  DATABASE_PASSWORD = "baserow"

  PUBLIC_BACKEND_URL      = "https://baserow-backend-example.rebelsoft.com"
  PUBLIC_WEB_FRONTEND_URL = "https://baserow-example.rebelsoft.com"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "backend" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"          = "baserow-backend-example.*"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
    }
    name      = module.backend.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.backend.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.backend.name
            service_port = module.backend.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "web-frontend" {
  source    = "../../modules/baserow/web-frontend"
  name      = "baserow-web-frontend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  PRIVATE_BACKEND_URL = "http://${module.backend.name}:${module.backend.ports[0].port}"
  PUBLIC_BACKEND_URL  = "https://baserow-backend-example.rebelsoft.com"
}


resource "k8s_networking_k8s_io_v1beta1_ingress" "web-frontend" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "baserow-example.*"
    }
    name      = module.web-frontend.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.web-frontend.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.web-frontend.name
            service_port = module.web-frontend.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
