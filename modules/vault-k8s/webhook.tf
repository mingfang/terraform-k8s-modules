resource "k8s_admissionregistration_k8s_io_v1_mutating_webhook_configuration" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  webhooks {
    name = "${var.name}.hashicorp.com"

    client_config {
      cabundle = ""

      service {
        name      = var.name
        namespace = var.namespace
        path      = "/mutate"
        port      = var.ports[0].port
      }
    }

    rules {
      api_groups   = [""]
      api_versions = ["v1"]
      resources    = ["deployments", "jobs", "pods", "statefulsets"]
      operations   = ["CREATE", "UPDATE"]
    }


    admission_review_versions = ["v1"]
    failure_policy            = "Ignore"
    side_effects              = "None"
    timeout_seconds           = 5
  }
}
