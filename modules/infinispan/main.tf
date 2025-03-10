locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "infinispan"
        image = var.image

        env = concat([
          {
            name  = "USER"
            value = var.USER
          },
          {
            name  = "PASS"
            value = var.PASS
          },
        ], var.env)

        volume_mounts = concat(
          var.configmap != null ? [
            {
              name       = "configmap"
              mount_path = "/home/kogito/data/protobufs"
            },
          ] : [],
        )
      }
    ]

    volumes = var.configmap != null ? [
      {
        config_map = {
          name = var.configmap
        }
        name = "configmap"
      },
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
