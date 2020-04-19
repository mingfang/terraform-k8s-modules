resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "aws_node_termination_handler" {
  metadata {
    name = "aws-node-termination-handler"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "aws-node-termination-handler"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "aws-node-termination-handler"
    namespace = var.namespace
  }
}