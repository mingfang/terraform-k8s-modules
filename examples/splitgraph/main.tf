resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "splitgraph" {
  source        = "../../modules/splitgraph"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  storage_class = "cephfs"
  storage       = "1Gi"
  replicas      = 1

  POSTGRES_USER     = "splitgraph"
  POSTGRES_PASSWORD = "splitgraph"
  POSTGRES_DB       = "splitgraph"
}
