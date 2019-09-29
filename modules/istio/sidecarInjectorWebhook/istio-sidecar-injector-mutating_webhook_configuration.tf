resource "k8s_admissionregistration_k8s_io_v1beta1_mutating_webhook_configuration" "istio-sidecar-injector" {
  metadata {
    labels = {
      "app"      = "sidecarInjectorWebhook"
      "chart"    = "sidecarInjectorWebhook"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-sidecar-injector"
    
  }

  webhooks {
    client_config {
      cabundle = ""
      service {
        name      = "istio-sidecar-injector"
        namespace = "${var.namespace}"
        path      = "/inject"
      }
    }
    failure_policy = "Fail"
    name           = "sidecar-injector.istio.io"
    namespace_selector {
      match_labels = {
        "istio-injection" = "enabled"
      }
    }

    rules {
      api_groups = [
        "",
      ]
      api_versions = [
        "v1",
      ]
      operations = [
        "CREATE",
      ]
      resources = [
        "pods",
      ]
    }
  }
}