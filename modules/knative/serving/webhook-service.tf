resource "k8s_core_v1_service" "webhook" {
  metadata {
    labels = {
      "role"                        = "webhook"
      "serving.knative.dev/release" = "devel"
    }
    name      = "webhook"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      port        = 443
      target_port = "443"
    }
    selector = {
      "role" = "webhook"
    }
  }
}