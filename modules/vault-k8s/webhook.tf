resource "k8s_admissionregistration_k8s_io_v1_mutating_webhook_configuration" "this" {
  metadata {
    name = var.name
  }

  webhooks {
    name = "vault.hashicorp.com"

    client_config {
      service {
        name      = var.name
        namespace = var.namespace
        path      = "/mutate"
        port      = var.ports[0].port
      }
      cabundle = ""
    }

    rules {
      operations   = ["CREATE", "UPDATE"]
      api_groups   = [""]
      api_versions = ["v1"]
      resources    = ["deployments", "jobs", "pods", "statefulsets"]
    }


    //not v1 compatible: expected webhook response of admission.k8s.io/v1, Kind=AdmissionReview, got /, Kind=
    admission_review_versions = ["v1beta1"]
    failure_policy            = "Ignore"
    side_effects              = "None"
    timeout_seconds           = 5
  }
}
