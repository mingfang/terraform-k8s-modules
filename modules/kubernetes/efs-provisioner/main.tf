locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = 1
    service_account_name = module.rbac.service_account.metadata[0].name

    containers = [
      {
        name  = "efs-provisioner"
        image = var.image

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
            name = "POD_NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name  = "FILE_SYSTEM_ID"
            value = var.FILE_SYSTEM_ID
          },
          {
            name  = "AWS_REGION"
            value = var.AWS_REGION
          },
          {
            name  = "DNS_NAME"
            value = var.DNS_NAME
          },
          {
            name  = "PROVISIONER_NAME"
            value = var.PROVISIONER_NAME
          },
        ]

        volume_mounts = [
          {
            name       = "pv-volume"
            mount_path = "/persistentvolumes"
            sub_path   = "persistentvolumes"
          }
        ]
      }
    ]

    strategy = {
      type = "Recreate"
    }

    volumes = [
      {
        name = "pv-volume"
        nfs = {
          server = var.DNS_NAME != null ? var.DNS_NAME : "${var.FILE_SYSTEM_ID}.efs.${var.AWS_REGION}.amazonaws.com"
          path   = "/"
        }
      }
    ]
  }
}

module "deployment-service" {
  source         = "../../../archetypes/deployment-service"
  parameters     = merge(local.parameters, var.overrides)
}
