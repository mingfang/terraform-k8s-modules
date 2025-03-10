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
        name  = "attu"
        image = var.image

        env = concat([
          {
            name  = "HOST_URL"
            value = var.HOST_URL
          },
          {
            name  = "MILVUS_URL"
            value = var.MILVUS_URL
          },
        ], var.env)

        resources = var.resources
      },
    ]

    node_selector = var.node_selector
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}