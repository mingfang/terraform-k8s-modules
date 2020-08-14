terraform {
  required_providers {
    k8s = {
      source = "mingfang/k8s"
    }
  }
}

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "superset"
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

        volume_mounts = var.config_secret_name != null ? [
          {
            name       = "config"
            mount_path = "/app/pythonpath"
          }
        ] : []
      },
    ]
    init_containers = [
      {
        name  = "init"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          superset db upgrade
          superset init
          EOF
        ]
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

        volume_mounts = var.config_secret_name != null ? [
          {
            name       = "config"
            mount_path = "/app/pythonpath"
          }
        ] : []
      },
    ]

    volumes = var.config_secret_name != null ? [
      {
        name = "config"
        secret = {
          default_mode = parseint("0777", 8)
          secret_name  = var.config_secret_name
        }
      }
    ] : []

  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}