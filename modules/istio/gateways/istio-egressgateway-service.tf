resource "k8s_core_v1_service" "istio-egressgateway" {
  metadata {
    labels = {
      "app"      = "istio-egressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "istio"    = "egressgateway"
      "release"  = "istio"
    }
    name      = "istio-egressgateway"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name = "http2"
      port = 80
    }
    ports {
      name = "https"
      port = 443
    }
    ports {
      name        = "tls"
      port        = 15443
      target_port = "15443"
    }
    selector = {
      "app"     = "istio-egressgateway"
      "istio"   = "egressgateway"
      "release" = "istio"
    }
    type = "ClusterIP"
  }
}