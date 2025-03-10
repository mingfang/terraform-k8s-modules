resource "k8s_core_v1_service_account" "cert_manager" {
  automount_service_account_token = true
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager"
    namespace = var.namespace
  }
}