resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "cert_manager_webhook_dynamic_serving" {
  metadata {
    labels = {
      "app"                         = "webhook"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "webhook"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name      = "cert-manager-webhook:dynamic-serving"
    namespace = var.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "cert-manager-webhook:dynamic-serving"
  }

  subjects {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "cert-manager-webhook"
    namespace = var.namespace
  }
}