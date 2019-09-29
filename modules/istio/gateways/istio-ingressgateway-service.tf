resource "k8s_core_v1_service" "istio-ingressgateway" {
  metadata {
    labels = {
      "app"      = "istio-ingressgateway"
      "chart"    = "gateways"
      "heritage" = "Tiller"
      "istio"    = "ingressgateway"
      "release"  = "istio"
    }
    name      = "istio-ingressgateway"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name        = "http2"
      node_port   = 31380
      port        = 80
      target_port = "80"
    }
    ports {
      name      = "https"
      node_port = 31390
      port      = 443
    }
    ports {
      name      = "tcp"
      node_port = 31400
      port      = 31400
    }
    ports {
      name        = "https-kiali"
      port        = 15029
      target_port = "15029"
    }
    ports {
      name        = "https-prometheus"
      port        = 15030
      target_port = "15030"
    }
    ports {
      name        = "https-grafana"
      port        = 15031
      target_port = "15031"
    }
    ports {
      name        = "https-tracing"
      port        = 15032
      target_port = "15032"
    }
    ports {
      name        = "tls"
      port        = 15443
      target_port = "15443"
    }
    ports {
      name        = "status-port"
      port        = 15020
      target_port = "15020"
    }
    selector = {
      "app"     = "istio-ingressgateway"
      "istio"   = "ingressgateway"
      "release" = "istio"
    }
    type = "${var.type}"
  }
}