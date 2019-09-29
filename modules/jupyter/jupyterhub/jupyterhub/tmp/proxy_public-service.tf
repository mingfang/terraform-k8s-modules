resource "k8s_core_v1_service" "proxy_public" {
  metadata {
    labels = {
      "app"       = "jupyterhub"
      "chart"     = "jupyterhub-0.8.2"
      "component" = "proxy-public"
      "heritage"  = "Helm"
      "release"   = "RELEASE-NAME"
    }
    name = "proxy-public"
  }
  spec {

    ports {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = "8000"
    }
    ports {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "443"
    }
    selector = {
      "component" = "proxy"
      "release"   = "RELEASE-NAME"
    }
    type = "LoadBalancer"
  }
}