resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "edges_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-instance"
      "package"  = "edge"
      "release"  = "istio"
    }
    name = "edges.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "edge"
      plural   = "edges"
      singular = "edge"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}