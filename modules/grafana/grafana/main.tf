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
    annotations = merge(var.annotations, {
      datasources-checksum = md5(data.template_file.datasources_file.rendered)
      dashboards-checksum  = md5(data.template_file.dashboards_file.rendered)
    })

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

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/datasources/datasources.yaml"
            sub_path   = "datasources.yaml"
          },
          {
            name       = "config"
            mount_path = "/etc/grafana/provisioning/dashboards/dashboards.yaml"
            sub_path   = "dashboards.yaml"
          },
        ]
      },
    ]

    volumes = [
      {
        config_map = {
          name = k8s_core_v1_config_map.this.metadata[0].name
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
