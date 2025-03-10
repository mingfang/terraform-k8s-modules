resource "k8s_core_v1_service" "enterprise-gateway" {
  metadata {
    labels = {
      "app"       = "enterprise-gateway"
      "component" = "enterprise-gateway"
    }
    name      = "enterprise-gateway"
    namespace = var.namespace
  }
  spec {

    ports {
      name        = "http"
      port        = 8888
      target_port = "8888"
    }
    selector = {
      "gateway-selector" = "enterprise-gateway"
    }
    session_affinity = "ClientIP"

  }
}