locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    // restart on config change
    annotations = merge(var.annotations, { checksum = module.config.checksum })

    containers = [
      {
        name  = "alertmanager"
        image = var.image

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

        args = [
          "--config.file=/etc/alertmanager/config.yml",
          "--storage.path=/alertmanager",
          "--cluster.advertise-address=$(POD_IP):6783",
        ]

        resources = var.resources

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/alertmanager/config.yml"
            sub_path   = "config.yml"
          },
        ]
      },
    ]

    volumes = [
      {
        name = "config"
        config_map = {
          name = module.config.name
        }
      },
    ]
  }
}

module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace
  from-map = {
    "config.yml" = file(coalesce(var.config_file, "${path.module}/config.yml"))
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}