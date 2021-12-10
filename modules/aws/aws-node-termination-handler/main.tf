locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name  = "node-termination-handler"
        image = var.image
        env = concat([
          {
            name = "NODE_NAME"
            value_from = {
              field_ref = {
                field_path = "spec.nodeName"
              }
            }
          },
          {
            name = "POD_NAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name = "SPOT_POD_IP"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "DELETE_LOCAL_DATA"
            value = var.DELETE_LOCAL_DATA
          },
          {
            name  = "IGNORE_DAEMON_SETS"
            value = var.IGNORE_DAEMON_SETS
          },
          {
            name  = "GRACE_PERIOD"
            value = var.GRACE_PERIOD
          },
          {
            name  = "POD_TERMINATION_GRACE_PERIOD"
            value = var.POD_TERMINATION_GRACE_PERIOD
          },
          {
            name  = "INSTANCE_METADATA_URL"
            value = var.INSTANCE_METADATA_URL
          },
          {
            name  = "NODE_TERMINATION_GRACE_PERIOD"
            value = var.NODE_TERMINATION_GRACE_PERIOD
          },
          {
            name  = "WEBHOOK_URL"
            value = var.WEBHOOK_URL
          },
          {
            name  = "WEBHOOK_HEADERS"
            value = var.WEBHOOK_HEADERS
          },
          {
            name  = "WEBHOOK_TEMPLATE"
            value = var.WEBHOOK_TEMPLATE
          },
          {
            name  = "DRY_RUN"
            value = "false"
          },
          {
            name  = "ENABLE_SPOT_INTERRUPTION_DRAINING"
            value = var.ENABLE_SPOT_INTERRUPTION_DRAINING
          },
          {
            name  = "ENABLE_SCHEDULED_EVENT_DRAINING"
            value = var.ENABLE_SCHEDULED_EVENT_DRAINING
          },
          {
            name  = "METADATA_TRIES"
            value = var.METADATA_TRIES
          },
          {
            name  = "CORDON_ONLY"
            value = var.CORDON_ONLY
          },
          {
            name  = "TAINT_NODE"
            value = var.TAINT_NODE
          },
          {
            name  = "JSON_LOGGING"
            value = var.JSON_LOGGING
          },
          {
            name  = "WEBHOOK_PROXY"
            value = var.WEBHOOK_PROXY
          },
          {
            name  = "UPTIME_FROM_FILE"
            value = var.UPTIME_FROM_FILE
          },
          {
            name  = "ENABLE_PROMETHEUS_SERVER"
            value = var.ENABLE_PROMETHEUS_SERVER
          },
          {
            name  = "PROMETHEUS_SERVER_PORT"
            value = "9092"
          }
        ], var.env)

        volume_mounts = [
          {
            name       = "uptime"
            mount_path = "/proc/uptime"
            read_only  = true
          },
        ]
      }
    ]

    priority_class_name  = "system-cluster-critical"
    resources            = var.resources
    service_account_name = module.rbac.name

    security_context = {
      read_only_root_filesystem = true
      run_asgroup               = 1000
      run_asnon_root            = true
      run_asuser                = 1000
    }

    tolerations = [
      {
        effect = "NoSchedule"
        key    = "CriticalAddonsOnly"
      },
      {
        effect = "NoSchedule"
        key    = "node.kubernetes.io/master"
      }
    ]

    volumes = [
      {
        name = "uptime"
        host_path = {
          path = "/proc/uptime"
        }
      },
    ]
  }
}

module "daemonset" {
  source     = "../../../archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
