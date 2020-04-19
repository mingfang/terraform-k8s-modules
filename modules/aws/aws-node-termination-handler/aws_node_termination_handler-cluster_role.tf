resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "aws_node_termination_handler" {
  metadata {
    name = "aws-node-termination-handler"
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
      "patch",
      "update",
    ]
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
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "pods/eviction",
    ]
    verbs = [
      "create",
    ]
  }
  rules {
    api_groups = [
      "extensions",
    ]
    resources = [
      "replicasets",
      "daemonsets",
    ]
    verbs = [
      "get",
    ]
  }
  rules {
    api_groups = [
      "apps",
    ]
    resources = [
      "daemonsets",
    ]
    verbs = [
      "get",
      "delete",
    ]
  }
}