resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "metallb-system_speaker" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name = "metallb-system:speaker"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "services",
      "endpoints",
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
      "",
    ]
    resources = [
      "events",
    ]
    verbs = [
      "create",
      "patch",
    ]
  }
  rules {
    api_groups = [
      "extensions",
    ]
    resource_names = [
      "speaker",
    ]
    resources = [
      "podsecuritypolicies",
    ]
    verbs = [
      "use",
    ]
  }
}