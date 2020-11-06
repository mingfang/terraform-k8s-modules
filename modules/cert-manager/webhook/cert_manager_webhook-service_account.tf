resource "k8s_core_v1_service_account" "cert_manager_webhook" {
  metadata {
    labels = {
      "app"                         = "webhook"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "webhook"
    }
    name      = "cert-manager-webhook"
    namespace = var.namespace
  }
}