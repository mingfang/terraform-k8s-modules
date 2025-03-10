resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "serverlessservices_networking_internal_knative_dev" {
  metadata {
    labels = {
      "knative.dev/crd-install"     = "true"
      "serving.knative.dev/release" = "devel"
    }
    name = "serverlessservices.networking.internal.knative.dev"
  }
  spec {
    group = "networking.internal.knative.dev"
    names {
      categories = [
        "all",
        "knative-internal",
        "networking",
      ]
      kind   = "ServerlessService"
      plural = "serverlessservices"
      short_names = [
        "sks",
      ]
      singular = "serverlessservice"
    }
    scope = "Namespaced"
    subresources {
    }
    version = "v1alpha1"
  }
}