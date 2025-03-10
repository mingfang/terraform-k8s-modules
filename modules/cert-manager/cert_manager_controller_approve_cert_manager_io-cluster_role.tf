resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_controller_approve_cert_manager_io" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "cert-manager"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name = "cert-manager-controller-approve:cert-manager-io"
  }

  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resource_names = [
      "issuers.cert-manager.io/*",
      "clusterissuers.cert-manager.io/*",
    ]
    resources = [
      "signers",
    ]
    verbs = [
      "approve",
    ]
  }
}