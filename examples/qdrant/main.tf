resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "qdrant" {
  source    = "../../modules/qdrant"
  name      = "qdrant"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1
}
