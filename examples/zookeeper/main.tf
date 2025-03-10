resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "zookeeper" {
  source    = "../../modules/zookeeper"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = var.replicas
  storage       = var.storage
  storage_class = var.storage_class
}