resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "reportnothings_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-instance"
      "package"  = "reportnothing"
      "release"  = "istio"
    }
    name = "reportnothings.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "reportnothing"
      plural   = "reportnothings"
      singular = "reportnothing"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}