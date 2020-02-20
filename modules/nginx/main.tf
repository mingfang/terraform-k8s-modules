/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "nginx"
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
        ], var.env)

        volume_mounts = var.default-conf != null ? [
          {
            name       = "config"
            mount_path = "/etc/nginx/conf.d/default.conf"
            sub_path   = "default.conf"
          },
        ] : []
      }
    ]

    volumes = var.default-conf != null ? [
      {
        config_map = {
          name = var.name
        }
        name = "config"
      },
    ] : []
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
