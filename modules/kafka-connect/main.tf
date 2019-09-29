locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "connect"
        image = var.image
        env = concat([
          {
            name  = "BOOTSTRAP_SERVERS"
            value = var.bootstrap_servers
          },
          {
            name  = "GROUP_ID"
            value = var.name
          },
          {
            name  = "CONFIG_STORAGE_TOPIC"
            value = "${var.name}_connect_configs"
          },
          {
            name  = "OFFSET_STORAGE_TOPIC"
            value = "${var.name}_connect_offsets"
          },
          {
            name  = "HOST_NAME"
            value = "0.0.0.0"
          },
        ], var.env)

        liveness_probe = {
          failure_threshold = 3

          http_get = {
            path   = "/"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
