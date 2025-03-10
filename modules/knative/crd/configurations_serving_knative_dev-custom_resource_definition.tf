resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "configurations_serving_knative_dev" {
  metadata {
    labels = {
      "knative.dev/crd-install"     = "true"
      "serving.knative.dev/release" = "devel"
    }
    name = "configurations.serving.knative.dev"
  }
  spec {

    additional_printer_columns {
      json_path = ".status.latestCreatedRevisionName"
      name      = "LatestCreated"
      type      = "string"
    }
    additional_printer_columns {
      json_path = ".status.latestReadyRevisionName"
      name      = "LatestReady"
      type      = "string"
    }
    additional_printer_columns {
      json_path = ".status.conditions[?(@.type=='Ready')].status"
      name      = "Ready"
      type      = "string"
    }
    additional_printer_columns {
      json_path = ".status.conditions[?(@.type=='Ready')].reason"
      name      = "Reason"
      type      = "string"
    }
    group = "serving.knative.dev"
    names {
      categories = [
        "all",
        "knative",
        "serving",
      ]
      kind   = "Configuration"
      plural = "configurations"
      short_names = [
        "config",
        "cfg",
      ]
      singular = "configuration"
    }
    scope = "Namespaced"
    subresources {
    }
    version = "v1alpha1"
  }
}