resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_controller_certificatesigningrequests" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "cert-manager"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name = "cert-manager-controller-certificatesigningrequests"
  }

  rules {
    api_groups = [
      "certificates.k8s.io",
    ]
    resources = [
      "certificatesigningrequests",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
    ]
  }
  rules {
    api_groups = [
      "certificates.k8s.io",
    ]
    resources = [
      "certificatesigningrequests/status",
    ]
    verbs = [
      "update",
    ]
  }
  rules {
    api_groups = [
      "certificates.k8s.io",
    ]
    resource_names = [
      "issuers.cert-manager.io/*",
      "clusterissuers.cert-manager.io/*",
    ]
    resources = [
      "signers",
    ]
    verbs = [
      "sign",
    ]
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