resource "k8s_core_v1_service" "hub" {
  metadata {
    annotations = {
      "prometheus.io/path"   = "/hub/metrics"
      "prometheus.io/scrape" = "true"
    }
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "hub"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "hub"
  }
  spec {

    ports {
      port        = 8081
      protocol    = "TCP"
      target_port = "8081"
    }
    selector = {
      "app"       = "jupyterhub"
      "component" = "hub"
      "release"   = "RELEASE-NAME"
    }
    type = "ClusterIP"
  }
}