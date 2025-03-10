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
        name  = "st2auth"
        image = var.image

        env = concat([
        ], var.env)

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/st2/st2.docker.conf"
            sub_path   = "st2.docker.conf"
          },
          {
            name       = "config"
            mount_path = "/etc/st2/htpasswd"
            sub_path   = "htpasswd"
          },
        ]

      }
    ]

    volumes = [
      {
        config_map = {
          name = var.config_map
        }
        name = "config"
      },
    ]

  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
