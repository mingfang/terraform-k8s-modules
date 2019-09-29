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
    annotations          = var.annotations
    replicas             = 1
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "bungeecord"
        image = var.image

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          },
          {
            mount_path = "/data/config.yml"
            name       = "config"
            sub_path   = "config.yml"
          },
        ]
      },
    ]

    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class_name
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
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


module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}