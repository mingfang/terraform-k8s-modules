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
        name  = "loki"
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
        ], var.env)

        resources = {
          requests = {
            cpu    = "500m"
            memory = "1Gi"
          }
        }

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/loki/local-config.yaml"
            sub_path   = "local-config.yaml"
          },
        ]
      },
    ]

    volumes = [
      {
        config_map = {
          name = module.config.name
        }
        name = "config"
      },
    ]
  }
}

module "config" {
  source    = "../../kubernetes/config-map"
  name      = var.name
  namespace = var.namespace
  from-map = {
    "local-config.yaml" = templatefile("${path.module}/config.yml", {
      cassandra = var.cassandra
    })
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}