resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = var.replicas

  storage       = "1Gi"
  storage_class = var.storage_class_name

  heap_size = "4g"
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "elasticsearch" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.${var.namespace}.*"
    }
    name      = module.elasticsearch.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = module.elasticsearch.name
      http {
        paths {
          backend {
            service_name = module.elasticsearch.name
            service_port = 9200
          }
          path = "/"
        }
      }
    }
  }
}