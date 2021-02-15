locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false
    annotations          = var.annotations

    containers = [
      {
        name  = "odoo"
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
            name  = "HOST"
            value = var.HOST
          },
          {
            name  = "USER"
            value = var.USER
          },
          {
            name  = "PASSWORD"
            value = var.PASSWORD
          },
        ], var.env)

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/var/lib/odoo"
          },
        ] : []
      }
    ]

    init_containers = [
      {
        name  = "init"
        image = var.image

        command = [
          "bash",
          "-cx",
          <<-EOF
          chown odoo /var/lib/odoo
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/var/lib/odoo"
          },
        ] : []
      },
    ]

    volumes = var.pvc != null ? [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc
        }
      },
    ] : []
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}