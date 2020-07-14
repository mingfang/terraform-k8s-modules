resource "k8s_apps_v1_daemon_set" "aws_node_termination_handler" {
  metadata {
    labels = {
      "app.kubernetes.io/instance" = "aws-node-termination-handler"
      "app.kubernetes.io/name"     = "aws-node-termination-handler"
      "app.kubernetes.io/version"  = "1.6.1"
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
        "kubernetes.io/os"           = "linux"
      }
    }
    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "aws-node-termination-handler"
          "app.kubernetes.io/name"     = "aws-node-termination-handler"
          "k8s-app"                    = "aws-node-termination-handler"
          "kubernetes.io/os"           = "linux"
        }
      }
      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {

              node_selector_terms {

                match_expressions {
                  key      = "kubernetes.io/os"
                  operator = "In"
                  values = [
                    "linux",
                  ]
                }
                match_expressions {
                  key      = "kubernetes.io/arch"
                  operator = "In"
                  values = [
                    "amd64",
                    "arm64",
                    "arm",
                  ]
                }
                match_expressions {
                  key      = "eks.amazonaws.com/compute-type"
                  operator = "NotIn"
                  values = [
                    "fargate",
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
          env {
            name  = "METADATA_TRIES"
            value = var.METADATA_TRIES
          }
          env {
            name  = "CORDON_ONLY"
            value = var.CORDON_ONLY
          }
          env {
            name  = "TAINT_NODE"
            value = var.TAINT_NODE
          }
          env {
            name  = "JSON_LOGGING"
            value = var.JSON_LOGGING
          }
          env {
            name  = "WEBHOOK_PROXY"
            value = var.WEBHOOK_PROXY
          }
          env {
            name  = "UPTIME_FROM_FILE"
            value = var.UPTIME_FROM_FILE
          }
          env {
            name  = "ENABLE_PROMETHEUS_SERVER"
            value = var.ENABLE_PROMETHEUS_SERVER
          }
          env {
            name  = "PROMETHEUS_SERVER_PORT"
            value = "9092"
          }
          image             = "amazon/aws-node-termination-handler:v1.6.1"
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
          security_context {

            read_only_root_filesystem = true
            run_asgroup               = 1000
            run_asnon_root            = true
            run_asuser                = 1000
          }

          volume_mounts {
            mount_path = "/proc/uptime"
            name       = "uptime"
            read_only  = true
          }
        }
        dns_policy   = "ClusterFirstWithHostNet"
        host_network = true
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        priority_class_name  = "system-node-critical"
        service_account_name = "aws-node-termination-handler"

        tolerations {
          operator = "Exists"
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