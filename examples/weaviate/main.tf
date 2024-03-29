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
  image = "semitechnologies/transformers-inference:sentence-transformers-msmarco-distilbert-base-v2"
#  image = "registry.rebelsoft.com/nlpaueb/legal-bert-base-uncased"
#  image = "registry.rebelsoft.com/pile-of-law/legalbert-large-1.7m-2"
}

module "qna-transformers" {
  source    = "../../modules/weaviate/qna-transformers"
  name      = "qna-transformers"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
#  image = "semitechnologies/qna-transformers:bert-large-uncased-whole-word-masking-finetuned-squad"
  image = "registry.rebelsoft.com/atharvamundada99/bert-large-question-answering-finetuned-legal"
}
module "ner-transformers" {
  source    = "../../modules/weaviate/ner-transformers"
  name      = "ner-transformers"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 0
}
module "text-spellcheck" {
  source    = "../../modules/weaviate/text-spellcheck"
  name      = "text-spellcheck"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
}

module "weaviate" {
  source    = "../../modules/weaviate/weaviate"
  name      = "weaviate"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = 4
  storage       = "1Gi"
  storage_class = "cephfs"

  env_map = {
    CONTEXTIONARY_URL          = "${module.contextionary.name}:${module.contextionary.ports[0].port}"
    TRANSFORMERS_INFERENCE_API = "http://${module.t2v-transformers.name}:${module.t2v-transformers.ports[0].port}"
    QNA_INFERENCE_API          = "http://${module.qna-transformers.name}:${module.qna-transformers.ports[0].port}"
#    NER_INFERENCE_API          = "http://${module.ner-transformers.name}:${module.ner-transformers.ports[0].port}"
    SPELLCHECK_INFERENCE_API   = "http://${module.text-spellcheck.name}:${module.text-spellcheck.ports[0].port}"
    QUERY_MAXIMUM_RESULTS = "100000"
  }
  ENABLE_MODULES            = "text2vec-contextionary,text2vec-transformers,qna-transformers,ner-transformers,text-spellcheck"
  DEFAULT_VECTORIZER_MODULE = "text2vec-contextionary"
  LOG_LEVEL = "debug"
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
