resource "k8s_core_v1_config_map" "kiali" {
  data = {
    "config.yaml" = <<-EOF
      istio_namespace: ${var.namespace}
      deployment:
        accessible_namespaces: ['**']
      auth:
        strategy: anonymous
      server:
        port: 20001
        web_root: /kiali
      external_services:
        tracing:
          url:
          in_cluster_url: http://tracing/jaeger
        grafana:
          url:
          in_cluster_url: http://grafana:3000
        prometheus:
          url: http://prometheus:9090

      EOF
  }
  metadata {
    labels = {
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "kiali"
    namespace = var.namespace
  }
}