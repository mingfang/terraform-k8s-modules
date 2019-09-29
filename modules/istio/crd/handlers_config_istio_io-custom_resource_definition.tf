resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "handlers_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-handler"
      "package"  = "handler"
      "release"  = "istio"
    }
    name = "handlers.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "handler"
      plural   = "handlers"
      singular = "handler"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}