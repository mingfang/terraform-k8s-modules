resource "k8s_rbac_authorization_k8s_io_v1beta1_role_binding" "cert_manager_cainjector_leaderelection" {
  metadata {
    labels = {
      "app"                          = "cainjector"
      "app.kubernetes.io/component"  = "cainjector"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "cainjector"
      "helm.sh/chart"                = "cert-manager-v0.14.0"
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