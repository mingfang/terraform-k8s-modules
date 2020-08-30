locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations

    enable_service_links = false

    containers = [
      {
        name  = "invoker"
        image = var.image
        command: [ "/bin/bash", "-c", ". /invoker-scripts/configureDNS.sh && /init.sh --uniqueName $(NODENAME)" ]
        env = concat([
          {
            name = "NODENAME"
            value_from = {
              field_ref = {
                field_path = "spec.nodeName"
              }
            }
          },
          {
            name  = "KAFKA_HOSTS"
            value = var.KAFKA_HOSTS
          },
        ], var.env)
      },
    ]
  }
}

module "daemonset" {
  source     = "../../../archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
