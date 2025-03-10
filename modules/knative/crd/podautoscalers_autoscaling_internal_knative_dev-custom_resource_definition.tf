resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "podautoscalers_autoscaling_internal_knative_dev" {
  metadata {
    labels = {
      "knative.dev/crd-install"     = "true"
      "serving.knative.dev/release" = "devel"
    }
    name = "podautoscalers.autoscaling.internal.knative.dev"
  }
  spec {

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
    group = "autoscaling.internal.knative.dev"
    names {
      categories = [
        "all",
        "knative-internal",
        "autoscaling",
      ]
      kind   = "PodAutoscaler"
      plural = "podautoscalers"
      short_names = [
        "kpa",
      ]
      singular = "podautoscaler"
    }
    scope = "Namespaced"
    subresources {
    }
    version = "v1alpha1"
  }
}