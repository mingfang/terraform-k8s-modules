resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio-pilot-istio-system" {
  metadata {
    labels = {
      "app"      = "pilot"
      "chart"    = "pilot"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-pilot-istio-system"
  }

  rules {
    api_groups = [
      "config.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "rbac.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "get",
      "watch",
      "list",
    ]
  }
  rules {
    api_groups = [
      "networking.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "*",
    ]
  }
  rules {
    api_groups = [
      "authentication.istio.io",
    ]
    resources = [
      "*",
    ]
    verbs = [
      "*",
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
      "*",
    ]
  }
  rules {
    api_groups = [
      "extensions",
    ]
    resources = [
      "ingresses",
      "ingresses/status",
    ]
    verbs = [
      "*",
    ]
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
      "list",
      "watch",
      "update",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "endpoints",
      "pods",
      "services",
      "namespaces",
      "nodes",
      "secrets",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}