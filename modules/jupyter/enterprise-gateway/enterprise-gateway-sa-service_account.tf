resource "k8s_core_v1_service_account" "enterprise-gateway-sa" {
  metadata {
    labels = {
      "app"       = "enterprise-gateway"
      "component" = "enterprise-gateway"
    }
    name      = "enterprise-gateway-sa"
    namespace = var.namespace
  }
}