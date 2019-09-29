locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "kafka-connect-ui"
        image = var.image

        env = concat([
          {
            name  = "CONNECT_URL"
            value = var.kafka_connect
          },
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
