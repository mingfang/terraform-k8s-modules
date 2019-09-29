/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    labels               = local.labels
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "orientdb"
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
          {
            name  = "ORIENTDB_NODE_NAME"
            value = "$(POD_NAME)"
          },
          {
            name  = "ORIENTDB_ROOT_PASSWORD"
            value = var.ORIENTDB_ROOT_PASSWORD
          },
          {
            name  = "ORIENTDB_OPTS_MEMORY"
            value = var.ORIENTDB_OPTS_MEMORY
          },
        ], var.env)

        command = [
          "bash",
          "-cex",
          <<-EOF
          /orientdb/bin/server.sh -Dserver.database.path=/data/$POD_NAME -Ddistributed=${var.distributed} ${var.args}
          EOF
        ]

        resources = {
          requests = {
            cpu    = "500m"
            memory = "4Gi"
          }
        }

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/orientdb/config/hazelcast.xml"
            sub_path   = "hazelcast.xml"
          },
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          }
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

    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ]
  }
}

module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}

