resource "k8s_core_v1_service" "frontend" {
  metadata {
    labels = {
      "app"  = "guestbook"
      "tier" = "frontend"
    }
    name = "frontend"
  }
  spec {

    ports {
      port = 80
    }
    selector = {
      "app"  = "guestbook"
      "tier" = "frontend"
    }
  }
}