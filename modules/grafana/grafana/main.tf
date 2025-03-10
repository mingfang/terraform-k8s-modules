

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name  = "grafana"
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

        volume_mounts = [for x in [
          var.grafana_ini_config_map_name != null ? {
            name       = "grafana-ini"
            mount_path = "/etc/grafana/grafana.ini"
            sub_path   = "grafana.ini"
          } : null,
          var.dashboards_config_map_name != null ? {
            name       = "dashboards"
            mount_path = "/etc/grafana/provisioning/dashboards"
          } : null,
          var.datasources_config_map != null ? {
            name       = "datasources"
            mount_path = "/etc/grafana/provisioning/datasources"
          } : null,
          var.pvc_name != null ? {
            name       = "data"
            mount_path = "/var/lib/grafana"
          } : null
        ] : x if x != null]
      },
    ]

    init_containers = var.pvc_name != null ? [
      {
        name  = "init"
        image = var.image
        command = [
          "sh",
          "-cx",
          "chown grafana /var/lib/grafana"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/var/lib/grafana"
          },
        ]
      }
    ] : []

    volumes = [for x in [
      var.grafana_ini_config_map_name != null ? {
        name = "grafana-ini"
        config_map = {
          name = var.grafana_ini_config_map_name
        }
      } : null,
      var.dashboards_config_map_name != null ? {
        name = "dashboards"
        config_map = {
          name = var.dashboards_config_map_name
        }
      } : null,
      var.datasources_config_map != null ? {
        name = "datasources"
        config_map = {
          name = var.datasources_config_map
        }
      } : null,
      var.pvc_name != null ? {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        }
      } : null,
    ] : x if x != null]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}