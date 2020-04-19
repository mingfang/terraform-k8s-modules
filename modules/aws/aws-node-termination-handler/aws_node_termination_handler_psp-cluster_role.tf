resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "aws_node_termination_handler_psp" {
  metadata {
    labels = {
      "app.kubernetes.io/instance" = "aws-node-termination-handler"
      "app.kubernetes.io/name"     = "aws-node-termination-handler"
      "app.kubernetes.io/version"  = "1.3.1"
      "k8s-app"                    = "aws-node-termination-handler"
    }
    name = "aws-node-termination-handler-psp"
  }

  rules {
    api_groups = [
      "policy",
    ]
    resource_names = [
      "aws-node-termination-handler",
    ]
    resources = [
      "podsecuritypolicies",
    ]
    verbs = [
      "use",
    ]
  }
}