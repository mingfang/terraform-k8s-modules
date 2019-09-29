resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "cloudwatches_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"     = "mixer"
      "istio"   = "mixer-adapter"
      "package" = "cloudwatch"
    }
    name = "cloudwatches.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "cloudwatch"
      plural   = "cloudwatches"
      singular = "cloudwatch"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}