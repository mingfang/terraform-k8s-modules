locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = 1
    service_account_name = module.rbac.service_account.metadata[0].name

    containers = [
      {
        name  = "cephfs-provisioner"
        image = var.image

        command = ["/usr/local/bin/cephfs-provisioner"]
        args    = ["-id=cephfs-provisioner-1"]

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
            name  = "PROVISIONER_NAME"
            value = var.PROVISIONER_NAME
          },
          {
            name  = "PROVISIONER_SECRET_NAMESPACE"
            value = var.namespace
          },
        ]
      }
    ]

    strategy = {
      type = "Recreate"
    }
  }
}

module "deployment-service" {
  source         = "../../../archetypes/deployment-service"
  parameters     = merge(local.parameters, var.overrides)
}
