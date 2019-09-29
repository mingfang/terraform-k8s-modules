resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "dogstatsds_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"     = "mixer"
      "istio"   = "mixer-adapter"
      "package" = "dogstatsd"
    }
    name = "dogstatsds.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "dogstatsd"
      plural   = "dogstatsds"
      singular = "dogstatsd"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}