locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    annotations          = var.annotations
    enable_service_links = false


    containers = [
      {
        name  = "hub"
        image = var.image

        liveness_probe = {
          http_get = {
            path = "/wd/hub/status"
            port = 4444
          }
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
