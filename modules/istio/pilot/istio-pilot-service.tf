resource "k8s_core_v1_service" "istio-pilot" {
  metadata {
    labels = {
      "app"      = "pilot"
      "chart"    = "pilot"
      "heritage" = "Tiller"
      "istio"    = "pilot"
      "release"  = "istio"
    }
    name      = "istio-pilot"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name = "grpc-xds"
      port = 15010
    }
    ports {
      name = "https-xds"
      port = 15011
    }
    ports {
      name = "http-legacy-discovery"
      port = 8080
    }
    ports {
      name = "http-monitoring"
      port = 15014
    }
    selector = {
      "istio" = "pilot"
    }
  }
}