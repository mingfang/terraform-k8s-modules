resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "k8s_core_v1_persistent_volume_claim" "data" {
  metadata {
    name      = var.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "s3fs"
  }
}

module "registry" {
  source    = "../../modules/docker-registry"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  pvc_name = k8s_core_v1_persistent_volume_claim.data.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = module.registry.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.registry.name
            service_port = module.registry.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
