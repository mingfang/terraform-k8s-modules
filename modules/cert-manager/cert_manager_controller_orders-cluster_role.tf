resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "cert_manager_controller_orders" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.10.1"
    }
    name = "cert-manager-controller-orders"
  }

  rules {
    api_groups = [
      "certmanager.k8s.io",
    ]
    resources = [
      "orders",
      "orders/status",
    ]
    verbs = [
      "update",
    ]
  }
  rules {
    api_groups = [
      "certmanager.k8s.io",
    ]
    resources = [
      "orders",
      "clusterissuers",
      "issuers",
      "challenges",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "certmanager.k8s.io",
    ]
    resources = [
      "challenges",
    ]
    verbs = [
      "create",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "certmanager.k8s.io",
    ]
    resources = [
      "orders/finalizers",
    ]
    verbs = [
      "update",
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