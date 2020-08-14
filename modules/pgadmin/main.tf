terraform {
  required_providers {
    k8s = {
      source = "mingfang/k8s"
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
        name  = "pgadmin"
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
            name  = "PGADMIN_DEFAULT_EMAIL"
            value = var.PGADMIN_DEFAULT_EMAIL
          },
          {
            name  = "PGADMIN_DEFAULT_PASSWORD"
            value = var.PGADMIN_DEFAULT_PASSWORD
          },
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}