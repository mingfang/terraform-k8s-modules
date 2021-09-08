locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    ports                = var.ports
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "media"
        image = var.image

        env = concat([
        ], var.env)

        volume_mounts = [
          {
            name       = "media"
            mount_path = "/baserow/media"
          },
        ]
      }
    ]

    volumes = [
      {
        name = "media"
        persistent_volume_claim = {
          claim_name = var.pvc_media
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
