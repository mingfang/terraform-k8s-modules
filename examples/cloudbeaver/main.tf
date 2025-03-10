resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "postgres" {
  source        = "../../modules/postgres"
  name          = "postgres"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = var.storage_class_name
  storage       = "1Gi"
  replicas      = 1

  env_map = {
    POSTGRES_USER     = "cloudbeaver"
    POSTGRES_PASSWORD = "cloudbeaver"
    POSTGRES_DB       = "cloudbeaver"
  }
}

resource "k8s_core_v1_persistent_volume_claim" "workspace" {
  metadata {
    name      = "workspace"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes = [
    "ReadWriteMany"]
    resources {
      requests = {
        "storage" = "1Gi"
      }
    }
    storage_class_name = var.storage_class_name
  }
}

module "cloudbeaver" {
  source    = "../../modules/cloudbeaver"
  name      = "cloudbeaver"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  pvc = k8s_core_v1_persistent_volume_claim.workspace.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "cloudbeaver" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "cloudbeaver-example.*"
    }
    name      = module.cloudbeaver.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.cloudbeaver.name
            service_port = module.cloudbeaver.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}

