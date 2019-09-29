resource "k8s_core_v1_service" "istio-policy" {
  metadata {
    annotations = {
      "networking.istio.io/exportTo" = "*"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "istio"    = "mixer"
      "release"  = "istio"
    }
    name      = "istio-policy"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name = "grpc-mixer"
      port = 9091
    }
    ports {
      name = "grpc-mixer-mtls"
      port = 15004
    }
    ports {
      name = "http-monitoring"
      port = 15014
    }
    selector = {
      "istio"            = "mixer"
      "istio-mixer-type" = "policy"
    }
  }
}