resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "attributemanifests_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "core"
      "package"  = "istio.io.mixer"
      "release"  = "istio"
    }
    name = "attributemanifests.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "attributemanifest"
      plural   = "attributemanifests"
      singular = "attributemanifest"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}