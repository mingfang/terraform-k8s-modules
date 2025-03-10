resource "k8s_apps_v1_deployment" "redis-slave" {
  metadata {
    name = "redis-slave"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        "app"  = "redis"
        "role" = "slave"
        "tier" = "backend"
      }
    }
    template {
      metadata {
        labels = {
          "app"  = "redis"
          "role" = "slave"
          "tier" = "backend"
        }
      }
      spec {

        containers {

          env {
            name  = "GET_HOSTS_FROM"
            value = "dns"
          }
          image = "gcr.io/google_samples/gb-redisslave:v1"
          name  = "slave"

          ports {
            container_port = 6379
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