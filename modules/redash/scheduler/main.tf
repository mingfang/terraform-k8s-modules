locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "scheduler"
        image = var.image
        args  = ["scheduler"]

        env = concat([
          {
            name  = "REDASH_DATABASE_URL"
            value = var.REDASH_DATABASE_URL
          },
          {
            name  = "REDASH_REDIS_URL"
            value = var.REDASH_REDIS_URL
          },
          {
            name  = "PYTHONUNBUFFERED"
            value = "0"
          },
          {
            name  = "QUEUES"
            value = var.QUEUES
          },
          {
            name  = "WORKERS_COUNT"
            value = var.WORKERS_COUNT
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
