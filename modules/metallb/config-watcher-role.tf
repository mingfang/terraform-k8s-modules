resource "k8s_rbac_authorization_k8s_io_v1_role" "config-watcher" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name      = "config-watcher"
    namespace = var.namespace
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }
}