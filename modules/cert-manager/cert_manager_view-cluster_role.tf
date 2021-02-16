resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_view" {
  metadata {
    labels = {
      "app"                                          = "cert-manager"
      "app.kubernetes.io/component"                  = "controller"
      "app.kubernetes.io/instance"                   = "cert-manager"
      "app.kubernetes.io/name"                       = "cert-manager"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
      "rbac.authorization.k8s.io/aggregate-to-view"  = "true"
    }
    name = "cert-manager-view"
  }

  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resources = [
      "certificates",
      "certificaterequests",
      "issuers",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "acme.cert-manager.io",
    ]
    resources = [
      "challenges",
      "orders",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}