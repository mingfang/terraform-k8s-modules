resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "external-attacher-runner" {
  metadata {
    name = "external-attacher-runner"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "persistentvolumes",
    ]
    verbs = [
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
      "nodes",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
  rules {
    api_groups = [
      "storage.k8s.io",
    ]
    resources = [
      "volumeattachments",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
    ]
  }
}