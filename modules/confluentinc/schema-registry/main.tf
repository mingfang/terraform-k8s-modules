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
        name  = "schema-registry"
        image = var.image
        env = concat([
          {
            name  = "SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS"
            value = var.SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS
          },
          {
            name = "SCHEMA_REGISTRY_KAFKASTORE_LISTENERS"
            value = "http://0.0.0.0:${var.ports[0].port}"
          },
          {
            name = "SCHEMA_REGISTRY_HOST_NAME"
            value = "${var.name}.${var.namespace}"
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
