resource "k8s_core_v1_service_account" "cert_manager_cainjector" {
  automount_service_account_token = true
  metadata {
    labels = {
      "app"                         = "cainjector"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cainjector"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager-cainjector"
    namespace = var.namespace
  }
}