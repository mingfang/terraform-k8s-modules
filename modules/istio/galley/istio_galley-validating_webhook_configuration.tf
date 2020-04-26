resource "k8s_admissionregistration_k8s_io_v1beta1_validating_webhook_configuration" "istio_galley" {
  metadata {
    labels = {
      "app"      = "galley"
      "chart"    = "galley"
      "heritage" = "Tiller"
      "istio"    = "galley"
      "release"  = "istio"
    }
    name = "istio-galley"
  }

  webhooks {
    client_config {
      cabundle = ""
      service {
        name      = "istio-galley"
        namespace = var.namespace
        path      = "/admitpilot"
      }
    }
    failure_policy = "Ignore"
    name           = "pilot.validation.istio.io"

    rules {
      api_groups = [
        "config.istio.io",
      ]
      api_versions = [
        "v1alpha2",
      ]
      operations = [
        "CREATE",
        "UPDATE",
      ]
      resources = [
        "httpapispecs",
        "httpapispecbindings",
        "quotaspecs",
        "quotaspecbindings",
      ]
    }
    rules {
      api_groups = [
        "rbac.istio.io",
      ]
      api_versions = [
        "*",
      ]
      operations = [
        "CREATE",
        "UPDATE",
      ]
      resources = [
        "*",
      ]
    }
    rules {
      api_groups = [
        "security.istio.io",
      ]
      api_versions = [
        "*",
      ]
      operations = [
        "CREATE",
        "UPDATE",
      ]
      resources = [
        "*",
      ]
    }
    rules {
      api_groups = [
        "authentication.istio.io",
      ]
      api_versions = [
        "*",
      ]
      operations = [
        "CREATE",
        "UPDATE",
      ]
      resources = [
        "*",
      ]
    }
    rules {
      api_groups = [
        "networking.istio.io",
      ]
      api_versions = [
        "*",
      ]
      operations = [
        "CREATE",
        "UPDATE",
      ]
      resources = [
        "destinationrules",
        "envoyfilters",
        "gateways",
        "serviceentries",
        "sidecars",
        "virtualservices",
      ]
    }
    side_effects = "None"
  }
  webhooks {
    client_config {
      cabundle = ""
      service {
        name      = "istio-galley"
        namespace = var.namespace
        path      = "/admitmixer"
      }
    }
    failure_policy = "Ignore"
    name           = "mixer.validation.istio.io"

    rules {
      api_groups = [
        "config.istio.io",
      ]
      api_versions = [
        "v1alpha2",
      ]
      operations = [
        "CREATE",
        "UPDATE",
      ]
      resources = [
        "rules",
        "attributemanifests",
        "adapters",
        "handlers",
        "instances",
        "templates",
      ]
    }
    side_effects = "None"
  }
}