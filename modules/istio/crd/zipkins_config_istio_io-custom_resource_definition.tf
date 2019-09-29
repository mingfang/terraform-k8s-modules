resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "zipkins_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"     = "mixer"
      "istio"   = "mixer-adapter"
      "package" = "zipkin"
    }
    name = "zipkins.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "zipkin"
      plural   = "zipkins"
      singular = "zipkin"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}