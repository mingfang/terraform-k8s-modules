locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "couchdb"
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
            name = "LIMITS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "limits.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name = "REQUESTS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "requests.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name = "COUCHDB_USER"
            value_from = {
              secret_key_ref = {
                key  = var.db_username_key
                name = var.db_secret_name
              }
            }
          },
          {
            name = "COUCHDB_PASSWORD"
            value_from = {
              secret_key_ref = {
                key  = var.db_password_key
                name = var.db_secret_name
              }
            }
          },
        ],
        var.NODENAME != null ? [
          {
            name  = "NODENAME"
            value = var.NODENAME
          },
        ] : [],
        var.NODENAME == null ? [
          {
            name = "NODENAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
        ] : []
        , var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/opt/couchdb/data"
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