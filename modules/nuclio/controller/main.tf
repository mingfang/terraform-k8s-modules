locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    enable_service_links = false

    containers = [
      {
        name  = var.name
        image = var.image

        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name = "NUCLIO_CONTROLLER_CRON_TRIGGER_CRON_JOB_IMAGE_NAME"
            value = var.NUCLIO_CONTROLLER_CRON_TRIGGER_CRON_JOB_IMAGE_NAME
          },
          {
            name = "NUCLIO_CONTROLLER_FUNCTION_MONITOR_INTERVAL"
            value = var.NUCLIO_CONTROLLER_FUNCTION_MONITOR_INTERVAL
          },
          {
            name = "NUCLIO_CONTROLLER_FUNCTION_OPERATOR_NUM_WORKERS"
            value = var.NUCLIO_CONTROLLER_FUNCTION_OPERATOR_NUM_WORKERS
          },
          {
            name = "NUCLIO_CONTROLLER_FUNCTION_EVENT_OPERATOR_NUM_WORKERS"
            value = var.NUCLIO_CONTROLLER_FUNCTION_EVENT_OPERATOR_NUM_WORKERS
          },
          {
            name = "NUCLIO_CONTROLLER_PROJECT_OPERATOR_NUM_WORKERS"
            value = var.NUCLIO_CONTROLLER_PROJECT_OPERATOR_NUM_WORKERS
          },
          {
            name = "NUCLIO_CONTROLLER_API_GATEWAY_OPERATOR_NUM_WORKERS"
            value = var.NUCLIO_CONTROLLER_API_GATEWAY_OPERATOR_NUM_WORKERS
          },
          {
            name = "NUCLIO_CONTROLLER_RESYNC_INTERVAL"
            value = var.NUCLIO_CONTROLLER_RESYNC_INTERVAL
          },
        ], var.env)

        resources = var.resources

        volume_mounts = concat(
          var.configmap != null ? [
          for k, v in var.configmap.data :
          {
            name       = "config"
            mount_path = "/etc/nuclio/config/platform/${k}"
            sub_path   = k
          }
          ] : [],
        )
      },
    ]

    node_selector = var.node_selector
    service_account_name = module.rbac.name

    volumes = concat(
      var.configmap != null ? [
        {
          name = "config"

          config_map = {
            name = var.configmap.metadata[0].name
          }
        }
      ] : [],
    )
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}