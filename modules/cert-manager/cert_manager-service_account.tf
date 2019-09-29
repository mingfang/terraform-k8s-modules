resource "k8s_core_v1_service_account" "cert_manager" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.10.1"
    }
    name      = "cert-manager"
    namespace = var.namespace
  }
}