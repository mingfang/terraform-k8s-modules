resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "elasticsearch" {
  source    = "../../modules/elasticsearch"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3

  storage       = "1Gi"
  storage_class = var.storage_class_name

  secret = module.cert_secret.secret
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "elasticsearch" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "${var.namespace}.*"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    name      = module.elasticsearch.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${var.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.elasticsearch.name
            service_port = module.elasticsearch.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}