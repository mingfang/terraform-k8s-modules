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
        name  = "alertmanager"
        image = var.image

        args = [
          "--config.file=/etc/alertmanager/alertmanager.yml",
          "--storage.path=/alertmanager",
          "--cluster.advertise-address=$(POD_IP):6783",
        ]

        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
        ], var.env)

        resources = var.resources

        volume_mounts = var.config_map != null ? [
          {
            name       = "config"
            mount_path = "/etc/alertmanager/alertmanager.yml"
            sub_path   = "alertmanager.yml"
          },
        ] : []
      }
    ]

    volumes = var.config_map != null ? [
      {
        config_map = {
          name = var.config_map
        }
        name = "config"
      },
    ] : []
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
