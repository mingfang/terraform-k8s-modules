locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports

    annotations = merge(
      var.annotations,
      { "checksum" = md5(join("", keys(local.config_map), values(local.config_map))) },
    )

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "skipper-server"
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
            name = "SPRING_CLOUD_CONFIG_ENABLED"
            value = "false"
          },
          {
            name = "SPRING_CLOUD_KUBERNETES_CONFIG_ENABLE_API"
            value = "false"
          },
          {
            name = "SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API"
            value = "false"
          },
          {
            name = "SPRING_CLOUD_KUBERNETES_SECRETS_PATHS"
            value = "/etc/secrets"
          },
          {
            name = "KUBERNETES_NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name  = "KUBERNETES_TRUST_CERTIFICATES"
            value = "false"
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/application.yaml"
            sub_path = "application.yaml"
            read_only  = true
          }
        ]
      },
    ]

    service_account_name = module.rbac.name

    volumes = [
      {
        name = "config"
        config_map = {
          name = module.config.name
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}