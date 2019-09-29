resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "cert_manager_edit" {
  metadata {
    labels = {
      "app"                                          = "cert-manager"
      "app.kubernetes.io/instance"                   = "cert-manager"
      "app.kubernetes.io/managed-by"                 = "Tiller"
      "app.kubernetes.io/name"                       = "cert-manager"
      "helm.sh/chart"                                = "cert-manager-v0.10.1"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit"  = "true"
    }
    name = "cert-manager-edit"
  }

  rules {
    api_groups = [
      "certmanager.k8s.io",
    ]
    resources = [
      "certificates",
      "certificaterequests",
      "issuers",
    ]
    verbs = [
      "create",
      "delete",
      "deletecollection",
      "patch",
      "update",
    ]
  }
}