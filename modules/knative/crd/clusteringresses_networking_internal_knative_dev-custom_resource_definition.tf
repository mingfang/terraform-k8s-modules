resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "clusteringresses_networking_internal_knative_dev" {
  metadata {
    labels = {
      "knative.dev/crd-install"     = "true"
      "serving.knative.dev/release" = "devel"
    }
    name = "clusteringresses.networking.internal.knative.dev"
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
    group = "networking.internal.knative.dev"
    names {
      categories = [
        "all",
        "knative-internal",
        "networking",
      ]
      kind     = "ClusterIngress"
      plural   = "clusteringresses"
      singular = "clusteringress"
    }
    scope = "Cluster"
    subresources {
    }
    version = "v1alpha1"
  }
}