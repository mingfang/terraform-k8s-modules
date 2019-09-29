resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio-cleanup-secrets-istio-system" {
  metadata {
    annotations = {
      "helm.sh/hook"               = "post-delete"
      "helm.sh/hook-delete-policy" = "hook-succeeded"
      "helm.sh/hook-weight"        = "2"
    }
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-cleanup-secrets-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-cleanup-secrets-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-cleanup-secrets-service-account"
    namespace = "${var.namespace}"
  }
}