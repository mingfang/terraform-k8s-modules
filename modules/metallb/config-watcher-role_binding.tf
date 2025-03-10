resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "config-watcher" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name      = "config-watcher"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "config-watcher"
  }

  subjects {
    kind = "ServiceAccount"
    name = "controller"
  }
  subjects {
    kind = "ServiceAccount"
    name = "speaker"
  }
}