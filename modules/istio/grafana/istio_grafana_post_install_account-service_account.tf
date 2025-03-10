resource "k8s_core_v1_service_account" "istio_grafana_post_install_account" {
  metadata {
    labels = {
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-grafana-post-install-account"
    namespace = var.namespace
  }
}