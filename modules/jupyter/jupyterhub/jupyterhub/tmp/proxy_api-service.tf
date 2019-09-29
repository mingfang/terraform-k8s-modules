resource "k8s_core_v1_service" "proxy_api" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "proxy-api"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "proxy-api"
  }
  spec {

    ports {
      port        = 8001
      protocol    = "TCP"
      target_port = "8001"
    }
    selector = {
      "app"       = "jupyterhub"
      "component" = "proxy"
      "release"   = "RELEASE-NAME"
    }
  }
}