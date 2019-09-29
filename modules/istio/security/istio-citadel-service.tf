resource "k8s_core_v1_service" "istio-citadel" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "istio"    = "citadel"
      "release"  = "istio"
    }
    name      = "istio-citadel"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name        = "grpc-citadel"
      port        = 8060
      protocol    = "TCP"
      target_port = "8060"
    }
    ports {
      name = "http-monitoring"
      port = 15014
    }
    selector = {
      "istio" = "citadel"
    }
  }
}