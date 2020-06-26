/**
 * [Docker Registry](https://docs.docker.com/registry/)
 *
 */

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = 1
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "registry"
        image = var.image
        env   = var.env

        resources = var.resources

        volume_mounts = var.pvc_name != null ? [
          {
            name       = "data"
            mount_path = "/var/lib/registry"
          },
        ] : []
      },
    ]

    volumes = var.pvc_name != null ? [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        }
      },
    ] : []
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}