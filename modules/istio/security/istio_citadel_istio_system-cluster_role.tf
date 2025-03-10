resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio_citadel_istio_system" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-citadel-istio-system"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
    ]
    verbs = [
      "create",
      "get",
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
      "create",
      "get",
      "watch",
      "list",
      "update",
      "delete",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "serviceaccounts",
      "services",
      "namespaces",
    ]
    verbs = [
      "get",
      "watch",
      "list",
    ]
  }
  rules {
    api_groups = [
      "authentication.k8s.io",
    ]
    resources = [
      "tokenreviews",
    ]
    verbs = [
      "create",
    ]
  }
}