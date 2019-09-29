resource "k8s_core_v1_service" "redis-slave" {
  metadata {
    labels = {
      "app"  = "redis"
      "role" = "slave"
      "tier" = "backend"
    }
    name = "redis-slave"
  }
  spec {

    ports {
      port = 6379
    }
    selector = {
      "app"  = "redis"
      "role" = "slave"
      "tier" = "backend"
    }
  }
}