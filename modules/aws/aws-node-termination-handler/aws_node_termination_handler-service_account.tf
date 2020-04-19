resource "k8s_core_v1_service_account" "aws_node_termination_handler" {
  metadata {
    labels = {
      "app.kubernetes.io/instance" = "aws-node-termination-handler"
      "app.kubernetes.io/name"     = "aws-node-termination-handler"
      "app.kubernetes.io/version"  = "1.3.1"
      "k8s-app"                    = "aws-node-termination-handler"
    }
    name      = "aws-node-termination-handler"
    namespace = var.namespace
  }
}