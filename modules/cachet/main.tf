locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "cachet"
        image = var.image
        env = concat([
          {
            name  = "DB_HOST"
            value = var.DB_HOST
          },
          {
            name  = "DB_DATABASE"
            value = var.DB_DATABASE
          },
          {
            name  = "DB_USERNAME"
            value = var.DB_USERNAME
          },
          {
            name  = "DB_PASSWORD"
            value = var.DB_PASSWORD
          },
          {
            name  = "APP_KEY"
            value = "base64:gezq4kickk6+QAwOUrxhao4D+95D+hsWkh9oNljOOa0="
          },
          {
            name  = "APP_DEBUG"
            value = "false"
          }
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}