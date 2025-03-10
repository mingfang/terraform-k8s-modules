resource "k8s_apps_v1_deployment" "plugin_registry" {
  metadata {
    labels = {
      "app"       = "che"
      "component" = "plugin-registry"
    }
    name = "plugin-registry"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app"       = "che"
        "component" = "plugin-registry"
      }
    }
    strategy {
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
      type = "RollingUpdate"
    }
    template {
      metadata {
        labels = {
          "app"       = "che"
          "component" = "plugin-registry"
        }
      }
      spec {

        containers {
          image             = var.image
          image_pull_policy = "Always"
          liveness_probe {
            http_get {
              path   = "/v3/plugins/"
              port   = "8080"
              scheme = "HTTP"
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 3
          }
          name = "che-plugin-registry"

          ports {
            container_port = 8080
          }
          readiness_probe {
            http_get {
              path   = "/v3/plugins/"
              port   = "8080"
              scheme = "HTTP"
            }
            initial_delay_seconds = 3
            period_seconds        = 10
            timeout_seconds       = 3
          }
          resources {
            limits = {
              "memory" = "256Mi"
            }
            requests = {
              "memory" = "16Mi"
            }
          }
        }
      }
    }
  }
}