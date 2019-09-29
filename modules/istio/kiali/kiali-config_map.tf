resource "k8s_core_v1_config_map" "kiali" {
  data = {
    "config.yaml" = <<-EOF
      istio_namespace: ${var.namespace}
      server:
        port: 20001
      external_services:
        istio:
          url_service_version: http://istio-pilot:8080/version
        jaeger:
          url: 
        grafana:
          url: 
      
      EOF
  }
  metadata {
    labels = {
      "app" = "kiali"
      "chart" = "kiali"
      "heritage" = "Tiller"
      "release" = "istio"
    }
    name = "kiali"
    namespace = "${var.namespace}"
  }
}