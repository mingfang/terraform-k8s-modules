resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "istio-reader" {
  metadata {
    name = "istio-reader"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "nodes",
      "pods",
      "services",
      "endpoints",
      "replicationcontrollers",
    ]
    verbs = [
      "get",
      "watch",
      "list",
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