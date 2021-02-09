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
        name  = "cloudbeaver"
        image = var.image

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/opt/cloudbeaver/workspace"
          },
        ] : [],
      }
    ]

    volumes = var.pvc != null ? [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc
        }
      },
    ] : [],
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
