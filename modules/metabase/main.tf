locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "metabase"
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

        volume_mounts = var.pvc_name != null ? [
          {
            name       = "data"
            mount_path = "/data"
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
          "chown metabase /data"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/data"
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