locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports

    enable_service_links = false

    containers = [
      {
        name  = "apigateway"
        image = var.image
        env = concat([
          {
            name  = "REDIS_HOST"
            value = var.REDIS_HOST
          },
          {
            name  = "REDIS_PORT"
            value = var.REDIS_PORT
          },
          {
            name = "PUBLIC_GATEWAY_URL"
            value_from = {
              config_map_keyref = {
                key  = "whisk_api_host_url"
                name = var.whisk_config_name
              }
            }
          },
          {
            name = "BACKEND_HOST"
            value_from = {
              config_map_keyref = {
                key  = "whisk_api_host_url"
                name = var.whisk_config_name
              }
            }
          }
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
