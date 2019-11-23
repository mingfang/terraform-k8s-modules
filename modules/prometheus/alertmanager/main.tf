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
    annotations = merge(var.annotations, { checksum = md5(data.template_file.config.rendered) })

    containers = [
      {
        name  = "alertmanager"
        image = var.image

        env = [
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
        ]

        args = [
          "--config.file=/etc/alertmanager/config.yml",
          "--storage.path=/alertmanager",
          "--cluster.advertise-address=$(POD_IP):6783",
        ]

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/alertmanager/config.yml"
            sub_path   = "config.yml"
          },
        ]
      }
    ]
    volumes = [
      {
        name = "config"

        config_map = {
          name = k8s_core_v1_config_map.this.metadata.0.name
        }
      },
    ]
  }
}

data "template_file" "config" {
  template = file(coalesce(var.config_file, "${path.module}/config.yml"))
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
