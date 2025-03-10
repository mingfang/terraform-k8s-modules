locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations
    replicas                    = var.replicas
    ports                       = var.ports

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "middlemanager"
        image = var.image
        args = ["middleManager"]

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
            name = "REQUESTS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "requests.memory"
                divisor  = "1Mi"
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
            name = "REQUESTS_CPU"
            value_from = {
              resource_field_ref = {
                resource = "requests.cpu"
                divisor  = "1"
              }
            }
          },
          {
            name = "LIMITS_CPU"
            value_from = {
              resource_field_ref = {
                resource = "limits.cpu"
                divisor  = "1"
              }
            }
          },
          {
            name  = "DRUID_XMS"
            value = "$(REQUESTS_MEMORY)M"
          },
          {
            name  = "DRUID_XMX"
            value = "$(LIMITS_MEMORY)M"
          },
          {
            name  = "druid_indexer_runner_javaOptsArray"
            value = jsonencode([
              "-Xmx$(LIMITS_MEMORY)m",
              "-XX:MaxDirectMemorySize=$(REQUESTS_MEMORY)m",
            ])
          },
          {
            name = "druid_worker_capacity"
            value = "$(REQUESTS_CPU)"
          },
          {
            name = "druid_zk_service_host"
            value = var.druid_zk_service_host
          },
          {
            name = "druid_metadata_storage_type"
            value = var.druid_metadata_storage_type
          },
          {
            name = "druid_metadata_storage_connector_connectURI"
            value = var.druid_metadata_storage_connector_connectURI
          },
          {
            name = "druid_metadata_storage_connector_user"
            value = var.druid_metadata_storage_connector_user
          },
          {
            name = "druid_metadata_storage_connector_password"
            value = var.druid_metadata_storage_connector_password
          },
          {
            name = "druid_extensions_loadList"
            value = jsonencode(var.druid_extensions_loadList)
          },
        ], var.env)

        resources = var.resources

        volume_mounts = var.volume_claim_template_name != null ? [
          {
            name       = var.volume_claim_template_name
            mount_path = "/opt/druid/var"
          },
        ] : []
      },
    ]

    init_containers = var.volume_claim_template_name != null ? [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          <<-EOF
          chown -R druid /opt/druid/var
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/opt/druid/var"
          },
        ]
      },
    ] : []

    volume_claim_templates = var.volume_claim_template_name != null ? [
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
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}