resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "cert_manager_controller_ingress_shim" {
  metadata {
    labels = {
      "app"                         = "cert-manager"
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "cert-manager"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name = "cert-manager-controller-ingress-shim"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cert-manager-controller-ingress-shim"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "cert-manager"
    namespace = var.namespace
  }
}