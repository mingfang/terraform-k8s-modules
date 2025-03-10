resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "metallb-system_controller" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name = "metallb-system:controller"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "services",
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
      "services/status",
    ]
    verbs = [
      "update",
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
}