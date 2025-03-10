resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "etcd" {
  source    = "../../modules/etcd"
  name      = "etcd"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 3

  storage_class = "cephfs"
  storage       = "1Gi"
}
