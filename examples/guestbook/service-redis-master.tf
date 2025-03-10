resource "k8s_core_v1_service" "redis-master" {
  metadata {
    labels = {
      "tier" = "backend"
      "app"  = "redis"
      "role" = "master"
    }
    name = "redis-master"
  }
  spec {

    ports {
      port        = 6379
      target_port = "6379"
    }
    selector = {
      "tier" = "backend"
      "app"  = "redis"
      "role" = "master"
    }
  }
}