resource "k8s_core_v1_config_map" "istio-grafana" {
  data = {
    "dashboardproviders.yaml" = <<-EOF
      apiVersion: 1
      providers:
      - disableDeletion: false
        folder: istio
        name: istio
        options:
          path: /var/lib/grafana/dashboards/istio
        orgId: 1
        type: file
      
      EOF
    "datasources.yaml" = <<-EOF
      apiVersion: 1
      datasources:
      - access: proxy
        editable: true
        isDefault: true
        jsonData:
          timeInterval: 5s
        name: Prometheus
        orgId: 1
        type: prometheus
        url: http://prometheus:9090
      
      EOF
  }
  metadata {
    labels = {
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
      "istio"    = "grafana"
      "release"  = "istio"
    }
    name      = "istio-grafana"
    namespace = "${var.namespace}"
  }
}