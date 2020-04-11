resource "k8s_admissionregistration_k8s_io_v1beta1_validating_webhook_configuration" "cert_manager_webhook" {
  metadata {
    annotations = {
      "cert-manager.io/inject-ca-from-secret" = "cert-manager/cert-manager-webhook-tls"
    }
    labels = {
      "app"                          = "webhook"
      "app.kubernetes.io/component"  = "webhook"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Helm"
      "app.kubernetes.io/name"       = "webhook"
      "helm.sh/chart"                = "cert-manager-v0.14.0"
    }
    name = "cert-manager-webhook"
  }

  webhooks {
    client_config {
      service {
        name      = "cert-manager-webhook"
        namespace = var.namespace
        path      = "/mutate"
      }
    }
    failure_policy = "Fail"
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
        "v1alpha2",
      ]
      operations = [
        "CREATE",
        "UPDATE",
      ]
      resources = [
        "*/*",
      ]
    }
    side_effects = "None"
  }
}