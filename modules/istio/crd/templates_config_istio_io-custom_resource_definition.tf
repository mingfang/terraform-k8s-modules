resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "templates_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-template"
      "package"  = "template"
      "release"  = "istio"
    }
    name = "templates.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind     = "template"
      plural   = "templates"
      singular = "template"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}