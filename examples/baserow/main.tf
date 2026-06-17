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

  env_map = {
    POSTGRES_USER     = "baserow"
    POSTGRES_PASSWORD = "baserow"
    POSTGRES_DB       = "baserow"
  }
}

resource "k8s_core_v1_persistent_volume_claim" "media" {
  metadata {
    name      = "media"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = var.storage_class_name
  }
}

module "backend" {
  source    = "../../modules/baserow/backend"
  name      = "baserow-backend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_media = k8s_core_v1_persistent_volume_claim.media.metadata[0].name

  REDIS_HOST        = module.redis.name
  DATABASE_HOST     = module.postgres.name
  DATABASE_NAME     = "baserow"
  DATABASE_USER     = "baserow"
  DATABASE_PASSWORD = "baserow"

  PUBLIC_BACKEND_URL      = "https://${var.namespace}.rebelsoft.com"
  PUBLIC_WEB_FRONTEND_URL = "https://${var.namespace}.rebelsoft.com"
  MEDIA_URL               = "https://${var.namespace}.rebelsoft.com/media/"
}

module "media" {
  source    = "../../modules/baserow/media"
  name      = "media"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_media = k8s_core_v1_persistent_volume_claim.media.metadata[0].name
}

module "web-frontend" {
  source    = "../../modules/baserow/web-frontend"
  name      = "baserow-web-frontend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  PRIVATE_BACKEND_URL     = "http://${module.backend.name}:${module.backend.ports[0].port}"
  PUBLIC_BACKEND_URL      = "https://${var.namespace}.rebelsoft.com"
  PUBLIC_WEB_FRONTEND_URL = "https://${var.namespace}.rebelsoft.com"
}


resource "k8s_networking_k8s_io_v1_ingress" "baserow" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = module.web-frontend.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = "${module.web-frontend.name}.${var.namespace}"
      http {
        paths {
          backend {
            service {
              name = module.web-frontend.name
              port {
                number = module.web-frontend.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
        paths {
          backend {
            service {
              name = module.backend.name
              port {
                number = module.backend.ports[0].port
              }
            }
          }
          path      = "/api"
          path_type = "ImplementationSpecific"
        }
        paths {
          backend {
            service {
              name = module.backend.name
              port {
                number = module.backend.ports[0].port
              }
            }
          }
          path      = "/ws"
          path_type = "ImplementationSpecific"
        }
        paths {
          backend {
            service {
              name = module.media.name
              port {
                number = module.media.ports[0].port
              }
            }
          }
          path      = "/media"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
