resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "cassandra" {
  source    = "../../modules/cassandra"
  name      = "cassandra"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas      = var.replicas
  storage       = "1Gi"
  storage_class = var.storage_class_name
}