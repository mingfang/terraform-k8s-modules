resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "sidecars_networking_istio_io" {
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
    name = "sidecars.networking.istio.io"
  }
  spec {
    group = "networking.istio.io"
    names {
      categories = [
        "istio-io",
        "networking-istio-io",
      ]
      kind     = "Sidecar"
      plural   = "sidecars"
      singular = "sidecar"
    }
    scope   = "Namespaced"
    version = "v1alpha3"
  }
}