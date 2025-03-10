resource "k8s_apps_v1_deployment" "autoscaler" {
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name      = "autoscaler"
    namespace = "${var.namespace}"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "autoscaler"
      }
    }
    template {
      metadata {
        annotations = {
          "sidecar.istio.io/inject" = "true"
        }
        labels = {
          "app" = "autoscaler"
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
          image = "gcr.io/knative-releases/github.com/knative/serving/cmd/autoscaler@sha256:442f99e3a55653b19137b44c1d00f681b594d322cb39c1297820eb717e2134ba"
          name  = "autoscaler"

          ports {
            container_port = 8080
            name           = "websocket"
          }
          ports {
            container_port = 9090
            name           = "metrics"
          }
          resources {
            limits = {
              "cpu"    = "300m"
              "memory" = "400Mi"
            }
            requests = {
              "cpu"    = "30m"
              "memory" = "40Mi"
            }
          }

          volume_mounts {
            mount_path = "/etc/config-autoscaler"
            name       = "config-autoscaler"
          }
          volume_mounts {
            mount_path = "/etc/config-logging"
            name       = "config-logging"
          }
          volume_mounts {
            mount_path = "/etc/config-observability"
            name       = "config-observability"
          }
        }
        service_account_name = "controller"

        volumes {
          config_map {
            name = "config-autoscaler"
          }
          name = "config-autoscaler"
        }
        volumes {
          config_map {
            name = "config-logging"
          }
          name = "config-logging"
        }
        volumes {
          config_map {
            name = "config-observability"
          }
          name = "config-observability"
        }
      }
    }
  }
}