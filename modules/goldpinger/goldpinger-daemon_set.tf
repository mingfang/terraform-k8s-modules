resource "k8s_apps_v1_daemon_set" "goldpinger" {
  metadata {
    labels = {
      "app" = "${var.name}"
    }
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
  spec {
    selector {
      match_labels = {
        "app" = "${var.name}"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "${var.name}"
        }
      }
      spec {

        containers {

          env {
            name  = "HOST"
            value = "0.0.0.0"
          }
          env {
            name  = "PORT"
            value = "80"
          }
          env {
            name = "HOSTNAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
          image = "docker.io/bloomberg/goldpinger:1.4.0"
          name  = "${var.name}"

          ports {
            container_port = 80
            name           = "http"
          }
        }
        service_account = "${var.name}-serviceaccount"
      }
    }
    update_strategy {
      type = "RollingUpdate"
    }
  }
}