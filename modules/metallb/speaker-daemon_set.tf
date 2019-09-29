resource "k8s_apps_v1_daemon_set" "speaker" {
  metadata {
    labels = {
      "app"       = "metallb"
      "component" = "speaker"
    }
    name      = "speaker"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "app"       = "metallb"
        "component" = "speaker"
      }
    }
    template {
      metadata {
        annotations = {
          "prometheus.io/port"   = "7472"
          "prometheus.io/scrape" = "true"
        }
        labels = {
          "app"       = "metallb"
          "component" = "speaker"
        }
      }
      spec {

        containers {
          args = [
            "--port=7472",
            "--config=config",
          ]

          env {
            name = "METALLB_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name = "METALLB_HOST"
            value_from {
              field_ref {
                field_path = "status.hostIP"
              }
            }
          }
          image             = "metallb/speaker:v0.8.1"
          image_pull_policy = "IfNotPresent"
          name              = "speaker"

          ports {
            container_port = 7472
            name           = "monitoring"
          }
          resources {
            limits = {
              "cpu"    = "100m"
              "memory" = "100Mi"
            }
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              add = [
                "NET_ADMIN",
                "NET_RAW",
                "SYS_ADMIN",
              ]
              drop = [
                "ALL",
              ]
            }
            read_only_root_filesystem = true
          }
        }
        host_network = true
        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
        service_account_name             = "speaker"
        termination_grace_period_seconds = 0

        tolerations {
          effect = "NoSchedule"
          key    = "node-role.kubernetes.io/master"
        }
      }
    }
  }
}