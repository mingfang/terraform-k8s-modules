locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    enable_service_links = false

    containers = [
      {
        name  = "quine"
        image = var.image

        env = concat([
        ], var.env)

        resources = var.resources

        liveness_probe = {
          http_get = {
            path = "/api/v1/admin/liveness"
            port = var.ports[0].port
          }
          initial_delay_seconds = 30
          period_seconds        = 5
        }

        volume_mounts = var.configmap != null ? [
        for k, v in var.configmap.data :
        {
          name       = "config"
          mount_path = "/${k}"
          sub_path   = k
        }
        ] : []
      },
    ]

    node_selector = var.node_selector

    volumes = var.configmap != null ? [
      {
        name = "config"

        config_map = {
          name = var.configmap.metadata[0].name
        }
      }
    ] : []
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}