resource "k8s_core_v1_persistent_volume_claim" "materialized" {
  metadata {
    name      = "materialized"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    resources { requests = { "storage" = "1Gi" } }
    storage_class_name = "cephfs"
  }
}


module "materialized" {
  source    = "../../modules/materialized"
  name      = "materialized"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  pvc       = k8s_core_v1_persistent_volume_claim.materialized.metadata[0].name
}



