resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "goldpinger_clusterrole" {
  metadata {
    name = "${var.namespace}-${var.name}"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "pods",
    ]
    verbs = [
      "list",
    ]
  }
}