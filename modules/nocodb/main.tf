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
        name  = "nocodb"
        image = var.image

        env = concat([
          {
            name  = "NC_DB_JSON"
            value = var.NC_DB_JSON
          },
        ], var.env)
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
