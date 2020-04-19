resource "k8s_policy_v1beta1_pod_security_policy" "aws_node_termination_handler" {
  metadata {
    annotations = {
      "seccomp.security.alpha.kubernetes.io/allowedProfileNames" = "*"
    }
    labels = {
      "app.kubernetes.io/instance" = "aws-node-termination-handler"
      "app.kubernetes.io/name"     = "aws-node-termination-handler"
      "app.kubernetes.io/version"  = "1.3.1"
      "k8s-app"                    = "aws-node-termination-handler"
    }
    name = "aws-node-termination-handler"
  }
  spec {

    allowed_capabilities = [
      "*",
    ]
    fsgroup {
      rule = "RunAsAny"
    }

    host_network = true



    run_asuser {
      rule = "RunAsAny"
    }
    selinux {
      rule = "RunAsAny"
    }
    supplemental_groups {
      rule = "RunAsAny"
    }
    volumes = [
      "*",
    ]
  }
}