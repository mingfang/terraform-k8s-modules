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
        name  = "telegraf"
        image = var.image

        env = concat([
          { name = "_APP_INFLUXDB_HOST", value = var._APP_INFLUXDB_HOST },
          { name = "_APP_INFLUXDB_PORT", value = var._APP_INFLUXDB_PORT },
        ], var.env)
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
