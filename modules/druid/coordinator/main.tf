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
        name  = "coordinator"
        image = var.image
        args  = ["coordinator"]

        env = concat([
          {
            name = "HOSTNAME"

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
            name  = "druid_zk_service_host"
            value = var.druid_zk_service_host
          },
          {
            name  = "druid_metadata_storage_type"
            value = var.druid_metadata_storage_type
          },
          {
            name  = "druid_metadata_storage_connector_connectURI"
            value = var.druid_metadata_storage_connector_connectURI
          },
          {
            name  = "druid_metadata_storage_connector_user"
            value = var.druid_metadata_storage_connector_user
          },
          {
            name  = "druid_metadata_storage_connector_password"
            value = var.druid_metadata_storage_connector_password
          },
          {
            name  = "druid_extensions_loadList"
            value = jsonencode(var.druid_extensions_loadList)
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = "tmp"
            mount_path = "/opt/druid/var"
          },
        ]
      },
    ]
    init_containers = [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          <<-EOF
          chown -R druid:druid /opt/druid/var
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "tmp"
            mount_path = "/opt/druid/var"
          },
        ]
      },
    ]

    volumes = [
      {
        name      = "tmp"
        empty_dir = {}
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}