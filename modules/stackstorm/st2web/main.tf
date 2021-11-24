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
        name  = "st2web"
        image = var.image

        env = concat([
          {
            name  = "ST2_AUTH_URL"
            value = var.ST2_AUTH_URL
          },
          {
            name  = "ST2_API_URL"
            value = var.ST2_API_URL
          },
          {
            name  = "ST2_STREAM_URL"
            value = var.ST2_STREAM_URL
          },
        ], var.env)

      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
