/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name = var.name
    namespace = var.namespace
    replicas = var.replicas
    ports = [
      {
        name = "http"
        port = var.port
      }
    ]
    containers = [
      {
        name = "metron"
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
        ]

        lifecycle = {
          post_start = {
            exec = {
              command = [
                "sh",
                "-c",
                "sv start sleep;",
              ]
            }
          }
        }

        volume_mounts = [
          {
            mount_path = "/storm/conf/storm.yaml"
            name       = "config"
            sub_path   = "storm.yaml"
          },
        ]
      }
    ]

    volumes = [
      {
        name = "config"

        config_map = {
          name = "${k8s_core_v1_config_map.this.metadata.name}"
        }
      },
    ]

  }
}


module "deployment-service" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
