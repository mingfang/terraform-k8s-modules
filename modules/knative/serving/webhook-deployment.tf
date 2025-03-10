resource "k8s_apps_v1_deployment" "webhook" {
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name      = "webhook"
    namespace = "${var.namespace}"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app"  = "webhook"
        "role" = "webhook"
      }
    }
    template {
      metadata {
        annotations = {
          "sidecar.istio.io/inject" = "false"
        }
        labels = {
          "app"  = "webhook"
          "role" = "webhook"
        }
      }
      spec {

        containers {

          env {
            name = "SYSTEM_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "CONFIG_LOGGING_NAME"
            value = "config-logging"
          }
          image = "gcr.io/knative-releases/github.com/knative/serving/cmd/webhook@sha256:d1ba3e2c0d739084ff508629db001619cea9cc8780685e85dd910363774eaef6"
          name  = "webhook"
          resources {
            limits = {
              "cpu"    = "200m"
              "memory" = "200Mi"
            }
            requests = {
              "cpu"    = "20m"
              "memory" = "20Mi"
            }
          }

          volume_mounts {
            mount_path = "/etc/config-logging"
            name       = "config-logging"
          }
        }
        service_account_name = "controller"

        volumes {
          config_map {
            name = "config-logging"
          }
          name = "config-logging"
        }
      }
    }
  }
}