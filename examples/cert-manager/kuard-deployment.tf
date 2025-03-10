resource "k8s_apps_v1_deployment" "kuard" {
  metadata {
    name = "kuard"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "kuard"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "kuard"
        }
      }
      spec {

        containers {
          image             = "gcr.io/kuar-demo/kuard-amd64:1"
          image_pull_policy = "Always"
          name              = "kuard"

          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}