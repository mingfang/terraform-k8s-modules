resource "k8s_apps_v1_deployment" "frontend" {
  metadata {
    name = "frontend"
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        "tier" = "frontend"
        "app"  = "guestbook"
      }
    }
    template {
      metadata {
        labels = {
          "app"  = "guestbook"
          "tier" = "frontend"
        }
      }
      spec {

        containers {

          env {
            name  = "GET_HOSTS_FROM"
            value = "dns"
          }
          image = "gcr.io/google-samples/gb-frontend:v4"
          name  = "php-redis"

          ports {
            container_port = 80
          }
          resources {
            requests = {
              "cpu"    = "100m"
              "memory" = "100Mi"
            }
          }
        }
      }
    }
  }
}