resource "k8s_rbac_authorization_k8s_io_v1beta1_role_binding" "cert_manager_webhook_webhook_authentication_reader" {
  metadata {
    labels = {
      "app"                          = "webhook"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "webhook"
      "helm.sh/chart"                = "cert-manager-v0.12.0"
    }
    name      = "cert-manager-webhook:webhook-authentication-reader"
    namespace = "kube-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "extension-apiserver-authentication-reader"
  }

  subjects {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "cert-manager-webhook"
    namespace = var.namespace
  }
}