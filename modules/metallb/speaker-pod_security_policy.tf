resource "k8s_policy_v1beta1_pod_security_policy" "speaker" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name      = "speaker"
  }
  spec {
    allow_privilege_escalation = false
    allowed_capabilities = [
      "NET_ADMIN",
      "NET_RAW",
      "SYS_ADMIN",
    ]
    fsgroup {
      rule = "RunAsAny"
    }
    host_network = true

    host_ports {
      max = 7472
      min = 7472
    }
    privileged = true
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