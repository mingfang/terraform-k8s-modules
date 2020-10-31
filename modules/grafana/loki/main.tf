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
        args  = concat(["-config.file=/etc/loki/local-config.yaml"], var.args)
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

        volume_mounts = concat(
          [
            {
              name       = "config"
              mount_path = "/etc/loki/local-config.yaml"
              sub_path   = "local-config.yaml"
            },
          ],
          [for tenant in keys(var.rules) :
            {
              name       = "rules-${tenant}"
              mount_path = "/loki/rules/${tenant}"
            }
          ]
        )
      },
    ]

    volumes = concat(
      [
        {
          name = "config"
          config_map = {
            name = module.config.name
          }
        },
      ],
      [for tenant in keys(var.rules) :
        {
          name = "rules-${tenant}"
          config_map = {
            name = "rules-${tenant}"
          }
        }
      ]
    )
  }
}

module "config" {
  source    = "../../kubernetes/config-map"
  name      = "config"
  namespace = var.namespace
  from-map = {
    "local-config.yaml" = templatefile(coalesce(var.config_file, "${path.module}/config.yaml"), {
      auth_enabled     = var.auth_enabled
      cassandra        = var.cassandra
      alertmanager_url = var.alertmanager_url
    })
  }
}

module "rules" {
  for_each  = var.rules
  source    = "../../kubernetes/config-map"
  name      = "rules-${each.key}"
  namespace = var.namespace
  from-map = {
    "rules.yaml" = file(each.value)
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}