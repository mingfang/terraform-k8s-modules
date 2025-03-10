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
        name  = "alertmanager"
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

        liveness_probe = {
          http_get = {
            path = "/-/ready"
            port = 9093
          }
          timeout_seconds = 30
        }
        readiness_probe = {
          http_get = {
            path = "/-/ready"
            port = 9093
          }
          timeout_seconds = 30
        }

        resources = var.resources

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/alertmanager"
          }
        ]
      },
    ]

    volumes = [
      {
        name = "config"
        config_map = {
          name = module.config.name
        }
      }
    ]
  }
}

module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace

  from-map = {
    "alertmanager.yml" = templatefile("${path.module}/alertmanager.yml", {
      gateway_url = var.gateway_url
    })
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}