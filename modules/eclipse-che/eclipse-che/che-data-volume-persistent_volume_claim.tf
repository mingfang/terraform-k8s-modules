resource "k8s_core_v1_persistent_volume_claim" "che-data-volume" {
  metadata {
    labels = {
      "app"       = "che"
      "component" = "che"
    }
    name = "che-data-volume"
  }
  spec {
    access_modes = [
      "ReadWriteOnce",
    ]
    resources {
      requests = {
        "storage" = "1Gi"
      }
    }
  }
}