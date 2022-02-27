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
        name  = "quine"
        image = var.image

        env = concat([
        ], var.env)

        resources = var.resources

        liveness_probe = {
          http_get = {
            path = "/api/v1/admin/liveness"
            port = var.ports[0].port
          }
          initial_delay_seconds = 30
          period_seconds        = 5
        }

        volume_mounts = var.quine_config != null ? [
          {
            name       = "quine-config"
            mount_path = "/quine.conf"
            sub_path   = "quine.conf"
          }
        ] : []
      },
    ]

    volumes = var.quine_config != null ? [
      {
        name = "quine-config"
        config_map = {
          name = var.quine_config
        }
      }
    ] : []


  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}