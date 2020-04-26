resource "k8s_core_v1_service_account" "istio_security_post_install_account" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-security-post-install-account"
    namespace = var.namespace
  }
}