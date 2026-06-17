resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "flink-jobmanager" {
  source    = "../../modules/flink/flink-jobmanager"
  name      = "jobmanager"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
  env_map = {
    FLINK_PROPERTIES = "jobmanager.rpc.address: jobmanager"
  }
}

module "flink-taskmanager" {
  source    = "../../modules/flink/flink-taskmanager"
  name      = "taskmanager"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  env_map = {
    FLINK_PROPERTIES = "jobmanager.rpc.address: jobmanager"
  }
}

resource "k8s_networking_k8s_io_v1_ingress" "jobmanager" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.flink-jobmanager.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service {
              name = module.flink-jobmanager.name
              port {
                number = module.flink-jobmanager.ports[0].port
              }
            }
          }
          path      = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}
