resource "k8s_rbac_authorization_k8s_io_v1_role" "cert_manager_webhook_dynamic_serving" {
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

  rules {
    api_groups = [
      "",
    ]
    resource_names = [
      "cert-manager-webhook-ca",
    ]
    resources = [
      "secrets",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
    ]
  }
  rules {
    api_groups = [
      "",
    ]
    resources = [
      "secrets",
    ]
    verbs = [
      "create",
    ]
  }
}