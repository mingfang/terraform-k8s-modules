locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "st2api"
        image = var.image

        env = concat([
          {
            name  = "ST2_AUTH_URL"
            value = var.ST2_AUTH_URL
          },
          {
            name  = "ST2_API_URL"
            value = var.ST2_API_URL
          },
          {
            name  = "ST2_STREAM_URL"
            value = var.ST2_STREAM_URL
          },
        ], var.env)

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/st2/st2.docker.conf"
            sub_path   = "st2.docker.conf"
          },
          {
            name       = "config-rbac-assignments"
            mount_path = "/opt/stackstorm/rbac/assignments"
          },
          {
            name       = "stackstorm-keys"
            mount_path = "/etc/st2/keys"
          },
          {
            name       = "stackstorm-packs-configs"
            mount_path = "/opt/stackstorm/configs"
          },
          {
            name       = "stackstorm-packs"
            mount_path = "/opt/stackstorm/packs"
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
          chown st2:st2 /etc/st2/keys
          chown st2:st2 /opt/stackstorm/configs
          chown st2:st2 /opt/stackstorm/packs

          st2-apply-rbac-definitions --config-file=/etc/st2/st2.conf --config-file=/etc/st2/st2.docker.conf
          st2-register-content --config-file=/etc/st2/st2.conf --config-file=/etc/st2/st2.docker.conf --register-all
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/st2/st2.docker.conf"
            sub_path   = "st2.docker.conf"
          },
          {
            name       = "config-rbac-assignments"
            mount_path = "/opt/stackstorm/rbac/assignments"
          },
          {
            name       = "stackstorm-keys"
            mount_path = "/etc/st2/keys"
          },
          {
            name       = "stackstorm-packs-configs"
            mount_path = "/opt/stackstorm/configs"
          },
          {
            name       = "stackstorm-packs"
            mount_path = "/opt/stackstorm/packs"
          },
        ]
      },
    ]

    volumes = [
      {
        name = "config"

        config_map = {
          name = var.config_map
        }
      },
      {
        name = "config-rbac-assignments"

        config_map = {
          name = var.config_map_rbac_assignments
        }
      },
      {
        name = "config-chatbot-aliases"

        config_map = {
          name = var.config_map_chatbot_aliases
        }
      },
      {
        name = "stackstorm-keys"

        persistent_volume_claim = {
          claim_name = var.stackstorm_keys_pvc_name
        }
      },
      {
        name = "stackstorm-packs-configs"

        persistent_volume_claim = {
          claim_name = var.stackstorm_packs_configs_pvc_name
        }
      },
      {
        name = "stackstorm-packs"
        persistent_volume_claim = {
          claim_name = var.stackstorm_packs_pvc_name
        }
      },
    ]

  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
