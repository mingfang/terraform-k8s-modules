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
        name  = "eve"
        image = var.image

        env = concat([
          {
            name  = "MONGO_URI"
            value = var.MONGO_URI
          },
          var.domain_config != null ? {
            name  = "DOMAIN_PATH"
            value = "/etc/eve/domain.json"
          } : null,
        ], var.env)

        resources = var.resources

        liveness_probe = {
          http_get = {
            path = "/"
            port = var.ports[0].port
          }
          initial_delay_seconds = 30
          period_seconds        = 5
        }

        volume_mounts = var.domain_config != null ? [
          {
            name       = "domain-config"
            mount_path = "/etc/eve/domain.json"
            sub_path   = "domain.json"
          }
        ] : []
      },
    ]

    volumes = var.domain_config != null ? [
      {
        name = "domain-config"
        config_map = {
          name = var.domain_config
        }
      }
    ] : []


  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}