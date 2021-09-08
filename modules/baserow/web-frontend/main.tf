locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    ports                = var.ports
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "web-frontend"
        image = var.image

        env = concat([
          {
            name  = "NODE_ENV"
            value = "production"
          },
          {
            name  = "PRIVATE_BACKEND_URL"
            value = var.PRIVATE_BACKEND_URL
          },
          {
            name  = "PUBLIC_BACKEND_URL"
            value = var.PUBLIC_BACKEND_URL
          },
          {
            name  = "PUBLIC_WEB_FRONTEND_URL"
            value = var.PUBLIC_WEB_FRONTEND_URL
          },
          {
            name  = "INITIAL_TABLE_DATA_LIMIT"
            value = var.INITIAL_TABLE_DATA_LIMIT
          },
        ], var.env)
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
