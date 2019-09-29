resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "hub" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "hub"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "hub"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "hub"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "hub"
    namespace = "$${var.namespace}"
  }
}