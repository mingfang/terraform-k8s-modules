locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "st2workflowengine"
        image = var.image

        env = concat([
        ], var.env)

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/st2/st2.docker.conf"
            sub_path   = "st2.docker.conf"
          },
          {
            name       = "stackstorm-keys"
            mount_path = "/etc/st2/keys"
          },
        ]

      }
    ]

    volumes = [
      {
        config_map = {
          name = var.config_map
        }
        name = "config"
      },
      {
        name = "stackstorm-keys"
        persistent_volume_claim = {
          claim_name = var.stackstorm_keys_pvc_name
        }
      },
    ]

  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
