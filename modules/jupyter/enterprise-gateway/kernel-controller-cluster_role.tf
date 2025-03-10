resource "k8s_rbac_authorization_k8s_io_v1beta1_cluster_role" "kernel-controller" {
  metadata {
    labels = {
      "app"       = "enterprise-gateway"
      "component" = "kernel"
    }
    name = "kernel-controller"
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "pods",
    ]
    verbs = [
      "get",
      "watch",
      "list",
      "create",
      "delete",
    ]
  }
}