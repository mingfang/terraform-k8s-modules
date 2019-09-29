resource "k8s_extensions_v1beta1_deployment" "che" {
  metadata {
    labels = {
      "app"       = "che"
      "component" = "che"
    }
    name = "che"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "che"
      }
    }
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          "app"       = "che"
          "component" = "che"
        }
      }
      spec {

        containers {

          env {
            name = "OPENSHIFT_KUBE_PING_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env_from {
            config_map_ref {
              name = "che"
            }
          }
          image             = "eclipse/che-server:7.1.0"
          image_pull_policy = "Always"
          liveness_probe {
            http_get {
              path   = "/api/system/state"
              port   = "8080"
              scheme = "HTTP"
            }
            initial_delay_seconds = 120
            timeout_seconds       = 10
          }
          name = "che"

          ports {
            container_port = 8080
            name           = "http"
          }
          ports {
            container_port = 8000
            name           = "http-debug"
          }
          ports {
            container_port = 8888
            name           = "jgroups-ping"
          }
          ports {
            container_port = 8087
            name           = "http-metrics"
          }
          readiness_probe {
            http_get {
              path   = "/api/system/state"
              port   = "8080"
              scheme = "HTTP"
            }
            initial_delay_seconds = 15
            timeout_seconds       = 60
          }
          resources {
            limits = {
              "memory" = "600Mi"
            }
            requests = {
              "memory" = "256Mi"
            }
          }
          security_context {
            run_asuser = 1724
          }

          volume_mounts {
            mount_path = "/data"
            name       = "che-data-volume"
          }
        }

        init_containers {
          command = [
            "chmod",
            "777",
            "/data",
          ]
          image = "busybox"
          name  = "fmp-volume-permission"

          volume_mounts {
            mount_path = "/data"
            name       = "che-data-volume"
          }
        }
        security_context {
          fsgroup = 1724
        }
        service_account_name = "che"

        volumes {
          name = "che-data-volume"
          persistent_volume_claim {
            claim_name = "che-data-volume"
          }
        }
      }
    }
  }
}