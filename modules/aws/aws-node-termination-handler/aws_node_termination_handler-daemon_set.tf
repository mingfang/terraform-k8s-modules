resource "k8s_apps_v1_daemon_set" "aws_node_termination_handler" {
  metadata {
    labels = {
      "app.kubernetes.io/instance" = "aws-node-termination-handler"
      "app.kubernetes.io/name"     = "aws-node-termination-handler"
      "app.kubernetes.io/version"  = "1.3.1"
      "k8s-app"                    = "aws-node-termination-handler"
    }
    name      = "aws-node-termination-handler"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "aws-node-termination-handler"
        "app.kubernetes.io/name"     = "aws-node-termination-handler"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "aws-node-termination-handler"
          "app.kubernetes.io/name"     = "aws-node-termination-handler"
          "k8s-app"                    = "aws-node-termination-handler"
        }
      }
      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {

              node_selector_terms {

                match_expressions {
                  key      = "beta.kubernetes.io/os"
                  operator = "In"
                  values = [
                    "linux",
                  ]
                }
                match_expressions {
                  key      = "beta.kubernetes.io/arch"
                  operator = "In"
                  values = [
                    "amd64",
                  ]
                }
              }
            }
          }
        }

        containers {

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name = "SPOT_POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
          env {
            name  = "DELETE_LOCAL_DATA"
            value = var.DELETE_LOCAL_DATA
          }
          env {
            name  = "IGNORE_DAEMON_SETS"
            value = var.IGNORE_DAEMON_SETS
          }
          env {
            name  = "GRACE_PERIOD"
            value = var.GRACE_PERIOD
          }
          env {
            name  = "POD_TERMINATION_GRACE_PERIOD"
            value = var.POD_TERMINATION_GRACE_PERIOD
          }
          env {
            name  = "INSTANCE_METADATA_URL"
            value = var.INSTANCE_METADATA_URL
          }
          env {
            name  = "NODE_TERMINATION_GRACE_PERIOD"
            value = var.NODE_TERMINATION_GRACE_PERIOD
          }
          env {
            name  = "WEBHOOK_URL"
            value = var.WEBHOOK_URL
          }
          env {
            name  = "WEBHOOK_HEADERS"
            value = var.WEBHOOK_HEADERS
          }
          env {
            name  = "WEBHOOK_TEMPLATE"
            value = var.WEBHOOK_TEMPLATE
          }
          env {
            name  = "DRY_RUN"
            value = "false"
          }
          env {
            name  = "ENABLE_SPOT_INTERRUPTION_DRAINING"
            value = var.ENABLE_SPOT_INTERRUPTION_DRAINING
          }
          env {
            name  = "ENABLE_SCHEDULED_EVENT_DRAINING"
            value = var.ENABLE_SCHEDULED_EVENT_DRAINING
          }
          image             = "amazon/aws-node-termination-handler:v1.3.1"
          image_pull_policy = "IfNotPresent"
          name              = "aws-node-termination-handler"
          resources {
            limits = {
              "cpu"    = "100m"
              "memory" = "128Mi"
            }
            requests = {
              "cpu"    = "50m"
              "memory" = "64Mi"
            }
          }

          volume_mounts {
            mount_path = "/proc/uptime"
            name       = "uptime"
          }
        }
        dns_policy           = "ClusterFirstWithHostNet"
        host_network         = true
        priority_class_name  = "system-node-critical"
        service_account_name = "aws-node-termination-handler"

        dynamic "tolerations" {
          for_each = var.tolerations
          content {
            effect             = lookup(tolerations.value, "effect", null)
            key                = lookup(tolerations.value, "key", null)
            operator           = lookup(tolerations.value, "operator", null)
            toleration_seconds = lookup(tolerations.value, "toleration_seconds", null)
            value              = lookup(tolerations.value, "value", null)
          }
        }

        volumes {
          host_path {
            path = "/proc/uptime"
          }
          name = "uptime"
        }
      }
    }
  }
}