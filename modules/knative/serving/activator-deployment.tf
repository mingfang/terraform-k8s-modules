resource "k8s_apps_v1_deployment" "activator" {
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name      = "activator"
    namespace = "${var.namespace}"
  }
  spec {
    selector {
      match_labels = {
        "app"  = "activator"
        "role" = "activator"
      }
    }
    template {
      metadata {
        annotations = {
          "sidecar.istio.io/inject" = "true"
        }
        labels = {
          "app"                         = "activator"
          "role"                        = "activator"
          "serving.knative.dev/release" = "devel"
        }
      }
      spec {

        containers {
          args = [
            "-logtostderr=false",
            "-stderrthreshold=FATAL",
          ]

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
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
          image = "gcr.io/knative-releases/github.com/knative/serving/cmd/activator@sha256:60630ac88d8cb67debd1e2ab1ecd6ec3ff6cbab2336dda8e7ae1c01ebead76c0"
          liveness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }
          }
          name = "activator"

          ports {
            container_port = 8080
            name           = "http1-port"
          }
          ports {
            container_port = 8081
            name           = "h2c-port"
          }
          ports {
            container_port = 9090
            name           = "metrics-port"
          }
          readiness_probe {
            http_get {
              path = "/healthz"
              port = "8080"
            }
          }
          resources {
            limits = {
              "cpu"    = "200m"
              "memory" = "600Mi"
            }
            requests = {
              "cpu"    = "20m"
              "memory" = "60Mi"
            }
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