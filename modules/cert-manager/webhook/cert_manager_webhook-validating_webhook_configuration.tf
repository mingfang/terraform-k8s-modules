resource "k8s_admissionregistration_k8s_io_v1_validating_webhook_configuration" "cert_manager_webhook" {
  metadata {
    annotations = {
      "cert-manager.io/inject-ca-from-secret" = "cert-manager/cert-manager-webhook-ca"
    }
    labels = {
      "app"                         = "webhook"
      "app.kubernetes.io/component" = "webhook"
      "app.kubernetes.io/instance"  = "cert-manager"
      "app.kubernetes.io/name"      = "webhook"
      "app.kubernetes.io/version"   = "v1.5.1"
    }
    name = "cert-manager-webhook"
  }

  webhooks {
    admission_review_versions = [
      "v1",
      "v1beta1",
    ]
    client_config {
      service {
        name      = "cert-manager-webhook"
        namespace = var.namespace
        path      = "/validate"
      }
    }
    failure_policy = "Fail"
    match_policy   = "Equivalent"
    name           = "webhook.cert-manager.io"
    namespace_selector {

      match_expressions {
        key      = "cert-manager.io/disable-validation"
        operator = "NotIn"
        values = [
          "true",
        ]
      }
      match_expressions {
        key      = "name"
        operator = "NotIn"
        values = [
          "cert-manager",
        ]
      }
    }

    rules {
      api_groups = [
        "cert-manager.io",
        "acme.cert-manager.io",
      ]
      api_versions = [
        "v1",
      ]
      operations = [
        "CREATE",
        "UPDATE",
      ]
      resources = [
        "*/*",
      ]
    }
    side_effects    = "None"
    timeout_seconds = 10
  }
}