locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name  = "cron"
        image = var.image
        args  = ["run", "cron"]

        env_from = [
          {
            config_map_ref = {
              name = var.env_config_map
            }
          },
        ]

        volume_mounts = var.etc_config_map != null ? [
          {
            name       = "etc"
            mount_path = "/etc/sentry"
          }
        ] : []
      },
    ]

    volumes = var.etc_config_map != null ? [
      {
        name = "etc"
        config_map = {
          name         = var.etc_config_map
          default_mode = parseint("0644", 8)
        }
      }
    ] : []
  }
}

module "deployment-service" {
  source         = "../../../archetypes/deployment-service"
  parameters     = merge(local.parameters, var.overrides)
  enable_service = false
}
