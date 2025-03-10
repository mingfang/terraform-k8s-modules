/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "ui"
        image = var.image

        command = [
          "nginx-debug",
          "-g",
          "daemon off;",
        ]

        volume_mounts = [
          {
            mount_path = "/etc/nginx/nginx.conf"
            name       = "config"
            sub_path   = "nginx.conf"
          },
          {
            mount_path = "/etc/nginx/conf.d/default.conf"
            name       = "config"
            sub_path   = "default.conf"
          },
        ]
      }
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
  source     = "git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
