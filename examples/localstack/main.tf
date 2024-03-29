resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "localstack" {
  source    = "../../modules/localstack"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  env_map = {
    AWS_ACCESS_KEY_ID     = "test"
    AWS_SECRET_ACCESS_KEY = "test"
    AWS_DEFAULT_REGION    = "us-east-1"
    AWS_ENDPOINT_URL      = "http://localhost:4566"
  }
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
            service_name = module.localstack.name
            service_port = module.localstack.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
