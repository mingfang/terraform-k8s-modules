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
        name  = "server"
        image = var.image

        env = concat([
          {
            name = "APPSMITH_REDIS_URL"
            value = var.APPSMITH_REDIS_URL
          },
          {
            name  = "APPSMITH_MONGODB_URI"
            value = var.APPSMITH_MONGODB_URI
          },
          {
            name  = "APPSMITH_ENCRYPTION_PASSWORD"
            value = var.APPSMITH_ENCRYPTION_PASSWORD
          },
          {
            name  = "APPSMITH_ENCRYPTION_SALT"
            value = var.APPSMITH_ENCRYPTION_SALT
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
