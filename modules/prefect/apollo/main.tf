terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "apollo"
        image = var.image
        env   = concat([
          {
            name = "HASURA_API_URL"
            value = var.HASURA_API_URL
          },
          {
            name = "PREFECT_API_URL"
            value = var.PREFECT_API_URL
          },
          {
            name = "PREFECT_API_HEALTH_URL"
            value = var.PREFECT_API_HEALTH_URL
          },
          {
            name = "PREFECT_SERVER__TELEMETRY__ENABLED"
            value = var.PREFECT_SERVER__TELEMETRY__ENABLED
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