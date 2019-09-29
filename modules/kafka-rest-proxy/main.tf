locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "kafka-rest-proxy"
        image = var.image
        env = concat([
          {
            name  = "KAFKA_REST_ZOOKEEPER_CONNECT"
            value = var.zookeeper
          },
          {
            name  = "KAFKA_REST_HOST_NAME"
            value = var.name
          },
          {
            name  = "KAFKA_REST_LISTENERS"
            value = "http://0.0.0.0:8000"
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
