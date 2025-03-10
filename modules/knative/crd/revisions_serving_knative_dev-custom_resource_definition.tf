resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "revisions_serving_knative_dev" {
  metadata {
    labels = {
      "knative.dev/crd-install"     = "true"
      "serving.knative.dev/release" = "devel"
    }
    name = "revisions.serving.knative.dev"
  }
  spec {

    additional_printer_columns {
      json_path = ".status.serviceName"
      name      = "Service Name"
      type      = "string"
    }
    additional_printer_columns {
      json_path = ".metadata.labels['serving\\.knative\\.dev/configurationGeneration']"
      name      = "Generation"
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
      kind   = "Revision"
      plural = "revisions"
      short_names = [
        "rev",
      ]
      singular = "revision"
    }
    scope = "Namespaced"
    subresources {
    }
    version = "v1alpha1"
  }
}