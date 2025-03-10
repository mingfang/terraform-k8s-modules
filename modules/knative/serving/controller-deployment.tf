resource "k8s_apps_v1_deployment" "controller" {
  metadata {
    labels = {
      "serving.knative.dev/release" = "devel"
    }
    name      = "controller"
    namespace = "${var.namespace}"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "controller"
      }
    }
    template {
      metadata {
        annotations = {
          "sidecar.istio.io/inject" = "false"
        }
        labels = {
          "app" = "controller"
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
          image = "gcr.io/knative-releases/github.com/knative/serving/cmd/controller@sha256:25af5f3adad8b65db3126e0d6e90aa36835c124c24d9d72ffbdd7ee739a7f571"
          name  = "controller"

          ports {
            container_port = 9090
            name           = "metrics"
          }
          resources {
            limits = {
              "cpu"    = "1"
              "memory" = "1000Mi"
            }
            requests = {
              "cpu"    = "100m"
              "memory" = "100Mi"
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