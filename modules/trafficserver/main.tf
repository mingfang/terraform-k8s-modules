locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "squid"
        image = var.image
        env   = var.env

        resources = var.resources
        ports = [
          {
            container_port = var.ports[0].port
            host_port      = var.host_port
          }
        ]
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}