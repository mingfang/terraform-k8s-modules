resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "cert_manager_cainjector" {
  metadata {
    labels = {
      "app"                         = "cainjector"
      "app.kubernetes.io/component" = "cainjector"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cainjector"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name = "cert-manager-cainjector"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cert-manager-cainjector"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "cert-manager-cainjector"
    namespace = var.namespace
  }
}