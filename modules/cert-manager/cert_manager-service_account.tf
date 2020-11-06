resource "k8s_core_v1_service_account" "cert_manager" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
    }
    name      = "cert-manager"
    namespace = var.namespace
  }
}