resource "k8s_core_v1_service" "csi_cephfsplugin_provisioner" {
  metadata {
    labels = {
      "app" = "csi-metrics"
    }
    name      = "csi-cephfsplugin-provisioner"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {

    ports {
      name        = "http-metrics"
      port        = 8080
      protocol    = "TCP"
      target_port = "8681"
    }
    selector = {
      "app" = "csi-cephfsplugin-provisioner"
    }
  }
}