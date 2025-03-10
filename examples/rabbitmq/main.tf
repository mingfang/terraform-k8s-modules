resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "rabbitmq" {
  source    = "../../modules/rabbitmq"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = var.replicas
  storage       = var.storage
  storage_class = var.storage_class

  RABBITMQ_ERLANG_COOKIE = "RABBITMQ_ERLANG_COOKIE"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "management" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "rabbitmq-example.*"
    }
    name      = module.rabbitmq.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.rabbitmq.name}-${var.namespace}"
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
resource "k8s_networking_k8s_io_v1beta1_ingress" "stomp" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "stomp-example.*"
    }
    name      = "stomp"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "stomp-${module.rabbitmq.name}-${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.rabbitmq.name
            service_port = module.rabbitmq.ports[3].port
          }
          path = "/"
        }
      }
    }
  }
}
