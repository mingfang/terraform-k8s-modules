resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio-mixer-istio-system" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-mixer-istio-system"
  }

  rules {
    api_groups = [
      "config.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "create",
      "get",
      "list",
      "watch",
      "patch",
    ]
  }
  rules {
    api_groups = [
      "apiextensions.k8s.io",
    ]
    resources = [
      "customresourcedefinitions",
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
      "configmaps",
      "endpoints",
      "pods",
      "services",
      "namespaces",
      "secrets",
      "replicationcontrollers",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "extensions",
      "apps",
    ]
    resources = [
      "replicasets",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}