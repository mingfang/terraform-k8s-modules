resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "registry" {
  source    = "../../modules/docker-registry"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "registry" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "registry-example.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
      "cert-manager.io/cluster-issuer"              = "letsencrypt-prod"
    }
    name      = module.registry.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "registry-example.rebelsoft.com"
      http {
        paths {
          backend {
            service_name = module.registry.name
            service_port = module.registry.service.spec[0].ports[0].port
          }
          path = "/"
        }
      }
    }
    tls {
      hosts = [
        "registry-example.rebelsoft.com"
      ]
      secret_name = "registry-example.rebelsoft.com"
    }
  }
}
