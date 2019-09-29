locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "kafka-topic-ui"
        image = var.image

        env = concat([
          {
            name  = "KAFKA_REST_PROXY_URL"
            value = var.kafka_rest_proxy
          },
          {
            name  = "PROXY"
            value = "true"
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
