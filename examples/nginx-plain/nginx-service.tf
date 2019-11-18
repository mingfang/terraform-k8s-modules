resource "k8s_core_v1_service" "nginx" {
  metadata {
    labels = {
      "app"     = "nginx"
      "name"    = "nginx"
      "service" = "nginx"
    }
    name      = "nginx"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {

    ports {
      name        = "http"
      port        = 80
    }
    selector = {
      "app"     = "nginx"
      "name"    = "nginx"
      "service" = "nginx"
    }
  }
}