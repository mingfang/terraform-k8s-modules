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
        args  = ["server"]

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
            name  = "REDASH_WEB_WORKERS"
            value = var.REDASH_WEB_WORKERS
          },
          {
            name  = "PYTHONUNBUFFERED"
            value = "0"
          },
        ], var.env)
      }
    ]

    init_containers = [
      {
        name  = "db-create"
        image = var.image
        args  = ["create_db"]

        env = concat([
          {
            name  = "REDASH_DATABASE_URL"
            value = var.REDASH_DATABASE_URL
          },
        ], var.env)
      },
      {
        name  = "db-upgrade"
        image = var.image
        args  = ["manage", "db", "upgrade"]

        env = concat([
          {
            name  = "REDASH_DATABASE_URL"
            value = var.REDASH_DATABASE_URL
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
