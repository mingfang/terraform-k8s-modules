resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "contextionary" {
  source    = "../../modules/weaviate/contextionary"
  name      = "contextionary"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  EXTENSIONS_STORAGE_ORIGIN = "http://weaviate:8080"
}

module "t2v-transformers" {
  source    = "../../modules/weaviate/t2v-transformers"
  name      = "t2v-transformers"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
}

module "weaviate" {
  source    = "../../modules/weaviate/weaviate"
  name      = "weaviate"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 1
  storage       = "1Gi"
  storage_class = "cephfs"

  ENABLE_MODULES             = "text2vec-contextionary, text2vec-transformers"
  DEFAULT_VECTORIZER_MODULE  = "text2vec-contextionary"
  CONTEXTIONARY_URL          = "contextionary:9999"
  TRANSFORMERS_INFERENCE_API = "http://t2v-transformers:8080"
}


resource "k8s_networking_k8s_io_v1beta1_ingress" "this" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"                 = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"    = "weaviate-example.*"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "10240m"
    }
    name      = module.weaviate.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = "${module.weaviate.name}.${var.namespace}"
      http {
        paths {
          backend {
            service_name = module.weaviate.name
            service_port = module.weaviate.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
