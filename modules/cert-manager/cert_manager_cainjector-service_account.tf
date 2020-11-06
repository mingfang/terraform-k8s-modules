resource "k8s_core_v1_service_account" "cert_manager_cainjector" {
  metadata {
    labels = {
      "app"                         = "cainjector"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cainjector"
    }
    name      = "cert-manager-cainjector"
    namespace = var.namespace
  }
}