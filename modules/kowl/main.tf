locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports     = var.ports

    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    enable_service_links = false

    containers = [
      {
        name  = "kowl"
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
            name  = "CONFIG_FILEPATH"
            value = "/etc/${var.name}/config.yml"
          },
        ], var.env)

        resources = var.resources

        volume_mounts = concat(
          var.configmap != null ? [
            for k, v in var.configmap.data :
            {
              name = "config"

              mount_path = "/etc/${var.name}/${k}"
              sub_path   = k
            }
          ] : [],
        )
      },
    ]

    node_selector = var.node_selector

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
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}