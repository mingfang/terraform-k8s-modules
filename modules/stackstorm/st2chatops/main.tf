locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "st2chatops"
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
          {
            name  = "HUBOT_ADAPTER"
            value = var.HUBOT_ADAPTER
          },
          {
            name  = "HUBOT_LOG_LEVEL"
            value = var.HUBOT_LOG_LEVEL
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
