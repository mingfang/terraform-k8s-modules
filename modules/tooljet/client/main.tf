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
        name  = "tooljet"
        image = var.image
        args  = ["openresty", "-g", "daemon off;"]

        env = concat([
          { name = "SERVER_HOST", value = var.SERVER_HOST },
        ], var.env)

        resources = var.resources
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}