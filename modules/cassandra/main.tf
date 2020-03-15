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

    containers = [
      {
        name  = "cassandra"
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
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "MAX_HEAP_SIZE"
            value = "512M"
          },
          {
            name  = "HEAP_NEWSIZE"
            value = "100M"
          },
          {
            name  = "CASSANDRA_LISTEN_ADDRESS"
            value = "$(POD_IP)"
          },
          {
            name  = "CASSANDRA_CLUSTER_NAME"
            value = var.CASSANDRA_CLUSTER_NAME
          },
          {
            name  = "CASSANDRA_DC"
            value = var.CASSANDRA_DC
          },
          {
            name  = "CASSANDRA_RACK"
            value = var.CASSANDRA_RACK
          },
          {
            name  = "CASSANDRA_ENDPOINT_SNITCH"
            value = var.CASSANDRA_ENDPOINT_SNITCH
          },
          {
            name  = "CASSANDRA_SEEDS"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
        ], var.env)

        lifecyle = {
          pre_stop = {
            exec = {
              command = ["/bin/sh", "-c", "nodetool drain"]
            }
          }
        }

        resources = {
          requests = {
            cpu    = "500m"
            memory = "1Gi"
          }
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          }
        ]
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
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}