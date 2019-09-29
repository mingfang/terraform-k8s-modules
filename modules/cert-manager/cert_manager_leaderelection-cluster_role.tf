resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "cert_manager_leaderelection" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.10.1"
    }
    name = "cert-manager-leaderelection"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
    ]
    verbs = [
      "get",
      "create",
      "update",
      "patch",
    ]
  }
}