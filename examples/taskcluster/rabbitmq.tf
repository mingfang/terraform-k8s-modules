module "rabbitmq" {
  source    = "../../modules/rabbitmq"
  name      = "rabbitmq"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  RABBITMQ_ERLANG_COOKIE = "RABBITMQ_ERLANG_COOKIE"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "management" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}-rabbitmq.*"
    }
    name      = module.rabbitmq.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.namespace}-rabbitmq"
      http {
        paths {
          backend {
            service_name = module.rabbitmq.name
            service_port = module.rabbitmq.ports[1].port
          }
          path = "/"
        }
      }
    }
  }
}
