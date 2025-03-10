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
    annotations = merge(var.annotations, { checksum = md5(join("", keys(k8s_core_v1_config_map.this.data), values(k8s_core_v1_config_map.this.data))) })

    containers = [
      {
        name  = "kube-griffiti"
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
            name  = "GRAFFITI_CONFIG"
            value = "/config/graffiti-config.yaml"
          },
        ], var.env)

        volume_mounts = [
          {
            name       = "webhook-certs"
            mount_path = "/tls"
          },
          {
            name       = "config"
            mount_path = "/config"
          },
        ]
      }
    ]

    service_account_name = module.rbac.service_account.metadata[0].name
    strategy = {
      type = "Recreate"
    }

    volumes = [
      {
        name = "webhook-certs"
        secret = {
          secret_name = var.secret_name
        }
      },
      {
        name = "config"
        config_map = {
          name = k8s_core_v1_config_map.this.metadata[0].name
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
