resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "redisquotas_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "mixer-adapter"
      "package"  = "redisquota"
      "release"  = "istio"
    }
    name = "redisquotas.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      kind     = "redisquota"
      plural   = "redisquotas"
      singular = "redisquota"
    }
    scope   = "Namespaced"
    version = "v1alpha2"
  }
}