resource "k8s_core_v1_service_account" "cert_manager_cainjector" {
  metadata {
    labels = {
      "app"                          = "cainjector"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cainjector"
      "helm.sh/chart"                = "cainjector-v0.10.1"
    }
    name      = "cert-manager-cainjector"
    namespace = var.namespace
  }
}