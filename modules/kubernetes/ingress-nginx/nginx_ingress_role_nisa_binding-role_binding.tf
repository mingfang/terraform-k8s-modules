resource "k8s_rbac_authorization_k8s_io_v1beta1_role_binding" "nginx-ingress-role-nisa-binding" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.name
  }

  subjects {
    kind      = "ServiceAccount"
    name      = var.name
    namespace = var.namespace
  }
}