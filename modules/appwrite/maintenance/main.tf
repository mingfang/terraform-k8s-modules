locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name    = "maintenance"
        image   = var.image
        command = ["maintenance"]

        env = concat([
          { name = "_APP_ENV", value = var._APP_ENV },
          { name = "_APP_REDIS_HOST", value = var._APP_REDIS_HOST },
          { name = "_APP_REDIS_PORT", value = var._APP_REDIS_PORT },
          { name = "_APP_MAINTENANCE_INTERVAL", value = var._APP_MAINTENANCE_INTERVAL },
          { name = "_APP_MAINTENANCE_RETENTION_EXECUTION", value = var._APP_MAINTENANCE_RETENTION_EXECUTION },
          { name = "_APP_MAINTENANCE_RETENTION_ABUSE", value = var._APP_MAINTENANCE_RETENTION_ABUSE },
          { name = "_APP_MAINTENANCE_RETENTION_AUDIT", value = var._APP_MAINTENANCE_RETENTION_AUDIT },
        ], var.env)
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
