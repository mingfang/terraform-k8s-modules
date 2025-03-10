locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    annotations          = var.annotations
    enable_service_links = false


    containers = [
      {
        name  = "hub"
        image = var.image

        env = concat([
          {
            name  = "HUB_HOST"
            value = var.HUB_HOST
          },
          {
            name  = "HUB_PORT"
            value = var.HUB_PORT
          },
        ], var.env)

        volume_mounts = [
          {
            name       = "shm"
            mount_path = "/dev/shm"
          }
        ]
      }
    ]

    volumes = [
      {
        name = "shm"
        empty_dir = {
          medium = "Memory"
        }
      },
    ]

  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
