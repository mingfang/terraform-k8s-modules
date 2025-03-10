resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_webhook_subjectaccessreviews" {
  metadata {
    labels = {
      "app"                         = "webhook"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "webhook"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name = "cert-manager-webhook:subjectaccessreviews"
  }

  rules {
    api_groups = [
      "authorization.k8s.io",
    ]
    resources = [
      "subjectaccessreviews",
    ]
    verbs = [
      "create",
    ]
  }
}