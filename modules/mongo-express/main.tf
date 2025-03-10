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
        name  = "mongo-express"
        image = var.image

        env = concat([
          {
            name  = "ME_CONFIG_MONGODB_ADMINUSERNAME"
            value = var.ME_CONFIG_MONGODB_ADMINUSERNAME
          },
          {
            name  = "ME_CONFIG_MONGODB_ADMINPASSWORD"
            value = var.ME_CONFIG_MONGODB_ADMINPASSWORD
          },
          {
            name  = "ME_CONFIG_MONGODB_URL"
            value = var.ME_CONFIG_MONGODB_URL
          },
          {
            name  = "ME_CONFIG_SITE_SESSIONSECRET"
            value = "sessionsecret"
          },
          {
            name  = "ME_CONFIG_SITE_COOKIESECRET"
            value = "cookiesecret"
          },
        ], var.env)

        resources = var.resources

        liveness_probe = {
          http_get = {
            path = "/status"
            port = var.ports[0].port
          }
          initial_delay_seconds = 30
          period_seconds        = 5
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}