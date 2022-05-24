locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = 1
    ports                = var.ports
    enable_service_links = false
    annotations          = var.annotations

    containers = concat([
      {
        name  = "code-server"
        image = var.image
        args  = var.args

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
            name = "NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
        ], var.env)

        resources = var.resources

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/home/coder"
          },
        ] : []
      }
    ], var.additional_containers)

    init_containers = [
      {
        name  = "init"
        image = var.image

        command = [
          "bash",
          "-cx",
          <<-EOF
          chown coder /home/coder
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/home/coder"
          },
        ] : []
      },
    ]

    node_selector = var.node_selector

    volumes = var.pvc != null ? [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc
        }
      },
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}