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
        name  = "control-center"
        image = var.image
        env = concat([
          {
            name  = "CONTROL_CENTER_ZOOKEEPER_CONNECT"
            value = var.CONTROL_CENTER_ZOOKEEPER_CONNECT
          },
          {
            name  = "CONTROL_CENTER_BOOTSTRAP_SERVERS"
            value = var.CONTROL_CENTER_BOOTSTRAP_SERVERS
          },
          {
            name  = "CONTROL_CENTER_SCHEMA_REGISTRY_URL"
            value = var.CONTROL_CENTER_SCHEMA_REGISTRY_URL
          },
          {
            name  = "CONTROL_CENTER_REPLICATION_FACTOR"
            value = var.CONTROL_CENTER_REPLICATION_FACTOR
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
