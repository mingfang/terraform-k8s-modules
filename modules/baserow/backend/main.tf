locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    ports                = var.ports
    replicas             = 1
    enable_service_links = false

    containers = [
      {
        name  = "backend"
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
            name  = "PRIVATE_BACKEND_URL"
            value = "http://${var.name}:${var.ports[0].port}"
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
            name  = "REDIS_HOST"
            value = var.REDIS_HOST
          },
          {
            name  = "REDIS_PORT"
            value = var.REDIS_PORT
          },
          {
            name  = "REDIS_USER"
            value = var.REDIS_USER
          },
          {
            name  = "REDIS_PASSWORD"
            value = var.REDIS_PASSWORD
          },
          {
            name  = "REDIS_PROTOCOL"
            value = var.REDIS_PROTOCOL
          },
          {
            name  = "DATABASE_NAME"
            value = var.DATABASE_NAME
          },
          {
            name  = "DATABASE_USER"
            value = var.DATABASE_USER
          },
          {
            name  = "DATABASE_PASSWORD"
            value = var.DATABASE_PASSWORD
          },
          {
            name  = "DATABASE_HOST"
            value = var.DATABASE_HOST
          },
          {
            name  = "DATABASE_PORT"
            value = var.DATABASE_PORT
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
