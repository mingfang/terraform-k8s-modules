resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "cert_manager_controller_clusterissuers" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.14.0"
    }
    name = "cert-manager-controller-clusterissuers"
  }

  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resources = [
      "clusterissuers",
      "clusterissuers/status",
    ]
    verbs = [
      "update",
    ]
  }
  rules {
    api_groups = [
      "cert-manager.io",
    ]
    resources = [
      "clusterissuers",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "secrets",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "update",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "events",
    ]
    verbs = [
      "create",
      "patch",
    ]
  }
}