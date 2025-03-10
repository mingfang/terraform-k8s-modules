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
  image     = "postgres:16"

  storage_class = "cephfs"
  storage       = "1Gi"

  env_map = {
    POSTGRES_USER     = "postgres"
    POSTGRES_PASSWORD = "postgres"
    POSTGRES_DB       = "postgres"
  }
}

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = "data"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "penpot-backend" {
  source    = "../../modules/penpot/backend"
  name      = "penpot-backend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env_map   = {
    PENPOT_FLAGS                       = "enable-registration enable-login-with-password disable-email-verification enable-smtp enable-prepl-server"
    PENPOT_SECRET_KEY                  = "BrBdkMLe4saB3hNpuNN7Xm6uJFExaMP8eIHWBdxSHWrFijTBA9S2L-IQoBP06Uw-KBgXf1pongLDC1PNVQomLw"
    PENPOT_PREPL_HOST                  = "0.0.0.0"
    PENPOT_PUBLIC_URI                  = "https://${var.namespace}.rebelsoft.com"
    PENPOT_DATABASE_URI                = "postgresql://postgres/postgres"
    PENPOT_DATABASE_USERNAME           = "postgres"
    PENPOT_DATABASE_PASSWORD           = "postgres"
    PENPOT_REDIS_URI                   = "redis://redis/0"
    PENPOT_ASSETS_STORAGE_BACKEND      = "assets-fs"
    PENPOT_STORAGE_ASSETS_FS_DIRECTORY = "/opt/data/assets"

    PENPOT_SMTP_DEFAULT_FROM     = "no-reply@example.com"
    PENPOT_SMTP_DEFAULT_REPLY_TO = "no-reply@example.com"
    PENPOT_SMTP_HOST             = "mailcatcher"
    PENPOT_SMTP_PORT             = 1025
    PENPOT_SMTP_USERNAME         = ""
    PENPOT_SMTP_PASSWORD         = ""
    PENPOT_SMTP_TLS              = false
    PENPOT_SMTP_SSL              = false
  }

  pvc            = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
  pvc_mount_path = "/opt/data/assets"
  pvc_user       = "penpot"
}

module "penpot-exporter" {
  source    = "../../modules/penpot/exporter"
  name      = "penpot-exporter"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env_map   = {
    PENPOT_REDIS_URI = "redis://redis/0"
  }
}

module "penpot-frontend" {
  source    = "../../modules/penpot/frontend"
  name      = "penpot-frontend"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  env_map   = {
    PENPOT_FLAGS = "enable-registration enable-login-with-password"
  }
  pvc            = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
  pvc_mount_path = "/opt/data/assets"
  pvc_user       = "penpot"
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
            service_name = module.penpot-frontend.name
            service_port = module.penpot-frontend.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "mailcatcher" {
  source    = "../../modules/mailcatcher"
  name      = "mailcatcher"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "mailcatcher" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-mailcatcher.*"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
    }
    name      = "${var.namespace}-mailcatcher"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-mailcatcher"
      http {
        paths {
          backend {
            service_name = module.mailcatcher.name
            service_port = module.mailcatcher.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
