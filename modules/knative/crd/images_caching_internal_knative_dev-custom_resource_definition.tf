resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "images_caching_internal_knative_dev" {
  metadata {
    labels = {
      "knative.dev/crd-install" = "true"
    }
    name = "images.caching.internal.knative.dev"
  }
  spec {
    group = "caching.internal.knative.dev"
    names {
      categories = [
        "all",
        "knative-internal",
        "caching",
      ]
      kind   = "Image"
      plural = "images"
      short_names = [
        "img",
      ]
      singular = "image"
    }
    scope = "Namespaced"
    subresources {
    }
    version = "v1alpha1"
  }
}