resource "k8s_core_v1_service_account" "istio-cleanup-secrets-service-account" {
  metadata {
    annotations = {
      "helm.sh/hook"               = "post-delete"
      "helm.sh/hook-delete-policy" = "hook-succeeded"
      "helm.sh/hook-weight"        = "1"
    }
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-cleanup-secrets-service-account"
    namespace = "${var.namespace}"
  }
}