locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
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
            name = "NUCLIO_AUTH_KIND"
            value = "nop"
          },
          {
            name = "NUCLIO_BUSYBOX_CONTAINER_IMAGE"
            value = var.NUCLIO_BUSYBOX_CONTAINER_IMAGE
          },
          {
            name = "NUCLIO_DASHBOARD_DEPLOYMENT_NAME"
            value = var.name
          },
          {
            name = "NUCLIO_DASHBOARD_REGISTRY_URL"
            value = var.NUCLIO_DASHBOARD_REGISTRY_URL
          },
          {
            name = "NUCLIO_DASHBOARD_RUN_REGISTRY_URL"
            value = var.NUCLIO_DASHBOARD_RUN_REGISTRY_URL
          },
          {
            name = "NUCLIO_DASHBOARD_IMAGE_NAME_PREFIX_TEMPLATE"
            value = var.NUCLIO_DASHBOARD_IMAGE_NAME_PREFIX_TEMPLATE
          },
          {
            name = "NUCLIO_CONTAINER_BUILDER_KIND"
            value = var.NUCLIO_CONTAINER_BUILDER_KIND
          },
          {
            name = "NUCLIO_KANIKO_CONTAINER_IMAGE"
            value = var.NUCLIO_KANIKO_CONTAINER_IMAGE
          },
          {
            name = "NUCLIO_KANIKO_INSECURE_PUSH_REGISTRY"
            value = var.NUCLIO_KANIKO_INSECURE_PUSH_REGISTRY
          },
          {
            name = "NUCLIO_KANIKO_PUSH_IMAGES_RETRIES"
            value = var.NUCLIO_KANIKO_PUSH_IMAGES_RETRIES
          },
          {
            name = "NUCLIO_KANIKO_JOB_DELETION_TIMEOUT"
            value = var.NUCLIO_KANIKO_JOB_DELETION_TIMEOUT
          },
          {
            name = "NUCLIO_MONITOR_DOCKER_DAEMON"
            value = var.NUCLIO_MONITOR_DOCKER_DAEMON
          },
          {
            name = "NUCLIO_MONITOR_DOCKER_DAEMON_INTERVAL"
            value = var.NUCLIO_MONITOR_DOCKER_DAEMON_INTERVAL
          },
          {
            name = "NUCLIO_MONITOR_DOCKER_DAEMON_MAX_CONSECUTIVE_ERRORS"
            value = var.NUCLIO_MONITOR_DOCKER_DAEMON_MAX_CONSECUTIVE_ERRORS
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
    service_account_name = var.service_account_name

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