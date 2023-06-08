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

module "redis" {
  source    = "../../modules/redis"
  name      = "redis"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

// pgadmin

resource "k8s_core_v1_persistent_volume_claim" "pgadmin" {
  metadata {
    name      = "pgadmin"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}

module "pgadmin" {
  source    = "../../modules/pgadmin"
  name      = "pgadmin"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc_name                 = k8s_core_v1_persistent_volume_claim.pgadmin.metadata[0].name
  PGADMIN_DEFAULT_EMAIL    = "postgres@example.com"
  PGADMIN_DEFAULT_PASSWORD = "postgres"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "pgadmin" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-pgadmin.*"
    }
    name      = module.pgadmin.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-pgadmin"
      http {
        paths {
          backend {
            service_name = module.pgadmin.name
            service_port = module.pgadmin.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

module "env" {
  source = "../../modules/kubernetes/env"
  from-file = "${path.module}/env"
}

module "chaosgenius-server" {
  source = "../../modules/chaosgenius/chaosgenius-server"
  name      = "chaosgenius-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = module.env.kubernetes_env
}

module "chaosgenius-scheduler" {
  source = "../../modules/chaosgenius/chaosgenius-scheduler"
  name      = "chaosgenius-scheduler"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = module.env.kubernetes_env
}
module "chaosgenius-worker-analytics" {
  source = "../../modules/chaosgenius/chaosgenius-worker-analytics"
  name      = "chaosgenius-worker-analytics"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = module.env.kubernetes_env
}
module "chaosgenius-worker-alerts" {
  source = "../../modules/chaosgenius/chaosgenius-worker-alerts"
  name      = "chaosgenius-worker-alerts"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = module.env.kubernetes_env
}

module "chaosgenius-webapp" {
  source = "../../modules/chaosgenius/chaosgenius-webapp"
  name      = "chaosgenius-webapp"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env = module.env.kubernetes_env
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "chaosgenius" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.chaosgenius-webapp.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.chaosgenius-webapp.name
            service_port = module.chaosgenius-webapp.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
