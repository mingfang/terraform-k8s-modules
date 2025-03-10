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
        name  = "restheart"
        image = var.image

        env = concat([
          {
            name  = "MONGO_URI"
            value = var.MONGO_URI
          },
        ], var.env)

        resources = var.resources

        liveness_probe = {
          http_get = {
            path = "/ping"
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