/**
 * Runs a NFS Server serving from an empheral empty dir.
 *
 * WARNING: For demonstration purpose only; You will loose data.
 *
 * Based on https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs
 */

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    ports                = var.ports
    replicas             = 1
    service_account_name = module.rbac.service_account.metadata[0].name

    containers = [
      {
        name  = "nfs-provisioner"
        image = var.image
        args = [
          "-provisioner=${var.name}"
        ]
        env = [
          {
            name = "POD_IP"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "SERVICE_NAME"
            value = var.name
          },
          {
            name = "POD_NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          }
        ]

        security_context = {
          capabilities = {
            add = [
              "DAC_READ_SEARCH",
              "SYS_RESOURCE",
            ]
          }
        }

        volume_mounts = [
          {
            mount_path = "/export"
            name       = "data"
          }
        ]
      }
    ]

    strategy = {
      type = "Recreate"
    }

    volumes = [
      {
        name = "data"

        empty_dir = {
          medium = var.medium
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
