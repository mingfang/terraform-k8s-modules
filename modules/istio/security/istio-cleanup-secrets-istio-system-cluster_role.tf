resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio-cleanup-secrets-istio-system" {
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
    name = "istio-cleanup-secrets-istio-system"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "secrets",
    ]
    verbs = [
      "list",
      "delete",
    ]
  }
}