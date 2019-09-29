resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "prometheus-istio-system" {
  metadata {
    labels = {
      "app"      = "prometheus"
      "chart"    = "prometheus"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "prometheus-istio-system"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "nodes",
      "services",
      "endpoints",
      "pods",
      "nodes/proxy",
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
    ]
    verbs = [
      "get",
    ]
  }
  rules {
    non_resource_urls = [
      "/metrics",
    ]
    verbs = [
      "get",
    ]
  }
}