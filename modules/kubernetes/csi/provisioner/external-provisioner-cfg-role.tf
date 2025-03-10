resource "k8s_rbac_authorization_k8s_io_v1_role" "external-provisioner-cfg" {
  metadata {
    name      = "${var.name}-cfg"
    namespace = var.namespace
  }

  rules {
    api_groups = [
      "",
    ]
    resources = [
      "endpoints",
    ]
    verbs = [
      "get",
      "watch",
      "list",
      "delete",
      "update",
      "create",
    ]
  }
  rules {
    api_groups = [
      "coordination.k8s.io",
    ]
    resources = [
      "leases",
    ]
    verbs = [
      "get",
      "watch",
      "list",
      "delete",
      "update",
      "create",
    ]
  }
}