resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "certificates_networking_internal_knative_dev" {
  metadata {
    labels = {
      "knative.dev/crd-install"     = "true"
      "serving.knative.dev/release" = "devel"
    }
    name = "certificates.networking.internal.knative.dev"
  }
  spec {

    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].status
        EOF
      name = "Ready"
      type = "string"
    }
    additional_printer_columns {
      json_path = <<-EOF
        .status.conditions[?(@.type=="Ready")].reason
        EOF
      name = "Reason"
      type = "string"
    }
    group = "networking.internal.knative.dev"
    names {
      categories = [
        "all",
        "knative-internal",
        "networking",
      ]
      kind   = "Certificate"
      plural = "certificates"
      short_names = [
        "kcert",
      ]
      singular = "certificate"
    }
    scope = "Namespaced"
    subresources {
    }
    version = "v1alpha1"
  }
}