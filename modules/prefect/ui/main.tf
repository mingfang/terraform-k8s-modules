locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "ui"
        image = var.image
        env   = concat([
          {
            name = "PREFECT_SERVER__GRAPHQL_URL"
            value = var.PREFECT_SERVER__GRAPHQL_URL
          },
        ],var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}