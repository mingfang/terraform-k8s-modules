locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "graphql-engine"
        image = var.image
        env   = concat([
          {
            name = "HASURA_GRAPHQL_DATABASE_URL"
            value = var.HASURA_GRAPHQL_DATABASE_URL
          },
          {
            name = "HASURA_GRAPHQL_ENABLE_CONSOLE"
            value = var.HASURA_GRAPHQL_ENABLE_CONSOLE
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