resource "k8s_core_v1_service" "kubernetes-dashboard" {
  metadata {
    labels = {
      "k8s-app" = "${var.name}"
    }
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      port        = 443
      target_port = "8443"
    }
    selector = {
      "k8s-app" = "${var.name}"
    }
  }
}