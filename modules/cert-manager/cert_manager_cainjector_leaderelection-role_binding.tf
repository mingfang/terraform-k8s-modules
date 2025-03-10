resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "cert_manager_cainjector_leaderelection" {
  metadata {
    labels = {
      "app"                         = "cainjector"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cainjector"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager-cainjector:leaderelection"
    namespace = "kube-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cert-manager-cainjector:leaderelection"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "cert-manager-cainjector"
    namespace = var.namespace
  }
}