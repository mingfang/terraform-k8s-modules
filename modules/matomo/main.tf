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
        name  = "matomo"
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
            name  = "MATOMO_DATABASE_HOST"
            value = var.MATOMO_DATABASE_HOST
          },
          {
            name  = "MATOMO_DATABASE_DBNAME"
            value = var.MATOMO_DATABASE_DBNAME
          },
          {
            name  = "MATOMO_DATABASE_USERNAME"
            value = var.MATOMO_DATABASE_USERNAME
          },
          {
            name  = "MATOMO_DATABASE_PASSWORD"
            value = var.MATOMO_DATABASE_PASSWORD
          },
        ], var.env)

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/var/www/html/config"
          },
        ]
      }
    ]

    volumes = [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
