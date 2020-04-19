resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "aws_node_termination_handler_psp" {
  metadata {
    labels = {
      "app.kubernetes.io/instance" = "aws-node-termination-handler"
      "app.kubernetes.io/name"     = "aws-node-termination-handler"
      "app.kubernetes.io/version"  = "1.3.1"
      "k8s-app"                    = "aws-node-termination-handler"
    }
    name = "aws-node-termination-handler-psp"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "aws-node-termination-handler-psp"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "aws-node-termination-handler"
    namespace = var.namespace
  }
}