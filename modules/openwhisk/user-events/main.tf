locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports

    enable_service_links  = false

    containers = [
      {
        name  = "user-events"
        image = var.image
        env = concat([
          {
            name  = "KAFKA_HOSTS"
            value = var.KAFKA_HOSTS
          },
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
