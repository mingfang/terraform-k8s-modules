locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "pgadmin"
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
            name  = "PGADMIN_DEFAULT_EMAIL"
            value = var.PGADMIN_DEFAULT_EMAIL
          },
          {
            name  = "PGADMIN_DEFAULT_PASSWORD"
            value = var.PGADMIN_DEFAULT_PASSWORD
          },
        ], var.env)

        volume_mounts = var.pvc_name != null ? [
          {
            name       = "data"
            mount_path = "/var/lib/pgadmin"
          },
        ] : []
      },
    ]

    init_containers = var.pvc_name != null ? [
      {
        name  = "init"
        image = var.image
        command = [
          "sh",
          "-cx",
          "chown pgadmin /var/lib/pgadmin"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/var/lib/pgadmin"
          },
        ]
      }
    ] : []

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