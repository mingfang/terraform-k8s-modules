/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    // restart on config change
    annotations = merge(var.annotations, { "configmap-uid" = k8s_core_v1_config_map.this.metadata[0].uid })

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
          name = var.name
        }
        name = "config"
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}