resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "kubernetes-dashboard-minimal" {
  metadata {
    name      = "${var.name}-minimal"
    namespace = "${var.namespace}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.name}-minimal"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
}