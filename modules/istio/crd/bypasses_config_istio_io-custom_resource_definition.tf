resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "bypasses_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-adapter"
      "package"  = "bypass"
      "release"  = "istio"
    }
    name = "bypasses.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "bypass"
      plural   = "bypasses"
      singular = "bypass"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}