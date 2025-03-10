resource "k8s_core_v1_service" "csi-attacher" {
  metadata {
    labels = {
      "app" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
  spec {

    ports {
      name = "dummy"
      port = 12345
    }
    selector = {
      "app" = var.name
    }
  }
}