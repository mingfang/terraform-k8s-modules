resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
    labels = {
      istio-injection = "enabled"
    }
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = 1
  storage_class = "cephfs"
  storage       = "1Gi"

  POSTGRES_DB       = "openproject"
  POSTGRES_USER     = "openproject"
  POSTGRES_PASSWORD = "openproject"
}

module "memcached" {
  source    = "../../modules/memcached"
  name      = "memcached"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_core_v1_persistent_volume_claim" "this" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    storage_class_name = "cephfs"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = { "storage" = "1Gi" }
    }
  }
}

module "openproject" {
  source    = "../../modules/openproject"
  name      = "openproject"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  pvc_name  = k8s_core_v1_persistent_volume_claim.this.metadata[0].name

  DATABASE_URL                        = "postgres://openproject:openproject@${module.postgres.name}/openproject"
  RAILS_CACHE_STORE                   = "memcache"
  OPENPROJECT_CACHE__MEMCACHE__SERVER = "${module.memcached.name}:11211"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "openproject-example.*"
    }
    name      = module.openproject.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.openproject.name
      http {
        paths {
          backend {
            service_name = module.openproject.name
            service_port = 8080
          }
          path = "/"
        }
      }
    }
  }
}
