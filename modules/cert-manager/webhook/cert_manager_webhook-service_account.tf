resource "k8s_core_v1_service_account" "cert_manager_webhook" {
  automount_service_account_token = true
  metadata {
    labels = {
      "app"                         = "webhook"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "webhook"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager-webhook"
    namespace = var.namespace
  }
}