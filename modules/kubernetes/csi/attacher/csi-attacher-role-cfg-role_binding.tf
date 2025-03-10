resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "csi-attacher-role-cfg" {
  metadata {
    name      = "${var.name}-role-cfg"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.name}-cfg"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = var.name
    namespace = var.namespace
  }
}