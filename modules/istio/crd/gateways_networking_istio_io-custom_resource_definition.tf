resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "gateways_networking_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-pilot"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "gateways.networking.istio.io"
  }
  spec {
    group = "networking.istio.io"
    names {
      categories = [
        "istio-io",
        "networking-istio-io",
      ]
      kind   = "Gateway"
      plural = "gateways"
      short_names = [
        "gw",
      ]
      singular = "gateway"
    }
    scope   = "Namespaced"
    version = "v1alpha3"
  }
}