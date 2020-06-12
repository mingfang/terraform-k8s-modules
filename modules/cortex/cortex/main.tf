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
        name  = "cortex"
        image = var.image
        args  = ["-config.file=/etc/cortex/config.yaml"]

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

        resources = var.resources

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/cortex/config.yaml"
            sub_path   = "config.yaml"
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
    "config.yaml" = templatefile("${path.module}/config.yml", {
      auth_enabled = var.auth_enabled
      cassandra    = var.cassandra
      keyspace     = var.keyspace
    })
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}