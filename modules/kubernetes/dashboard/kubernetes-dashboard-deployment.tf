resource "k8s_apps_v1_deployment" "kubernetes-dashboard" {
  metadata {
    labels = {
      "k8s-app" = "${var.name}"
    }
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "k8s-app" = "${var.name}"
      }
    }
    template {
      metadata {
        labels = {
          "k8s-app" = "${var.name}"
        }
      }
      spec {

        containers {
          args = [
            "--auto-generate-certificates",
          ]
          image = "k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1"
          liveness_probe {
            http_get {
              path   = "/"
              port   = "8443"
              scheme = "HTTPS"
            }
            initial_delay_seconds = 30
            timeout_seconds       = 30
          }
          name = "${var.name}"

          ports {
            container_port = 8443
            protocol       = "TCP"
          }

          volume_mounts {
            mount_path = "/certs"
            name       = "${var.name}-certs"
          }
          volume_mounts {
            mount_path = "/tmp"
            name       = "tmp-volume"
          }
        }
        service_account_name = "${var.name}"

        tolerations {
          effect = "NoSchedule"
          key    = "node-role.kubernetes.io/master"
        }

        volumes {
          name = "${var.name}-certs"
          secret {
            secret_name = "${var.name}-certs"
          }
        }
        volumes {
          empty_dir {
          }
          name = "tmp-volume"
        }
      }
    }
  }
}