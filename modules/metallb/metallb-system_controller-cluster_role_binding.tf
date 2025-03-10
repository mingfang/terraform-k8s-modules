resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "metallb-system_controller" {
  metadata {
    labels = {
      "app" = "metallb"
    }
    name = "metallb-system:controller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "metallb-system:controller"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "controller"
    namespace = var.namespace
  }
}