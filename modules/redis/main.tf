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
        name  = "redis"
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


        resources = var.resources

        volume_mounts = var.pvc_name != null ? [
          {
            name       = "data"
            mount_path = "/data"
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