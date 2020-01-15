resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_webhook_webhook_requester" {
  metadata {
    labels = {
      "app"                          = "webhook"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "webhook"
      "helm.sh/chart"                = "cert-manager-v0.12.0"
    }
    name = "cert-manager-webhook:webhook-requester"
  }

  rules {
    api_groups = [
      "admission.cert-manager.io",
    ]
    resources = [
      "certificates",
      "certificaterequests",
      "issuers",
      "clusterissuers",
    ]
    verbs = [
      "create",
    ]
  }
}