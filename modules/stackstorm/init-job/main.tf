locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations

    containers = [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          <<-EOF
        st2-apply-rbac-definitions --config-file=/etc/st2/st2.conf --config-file=/etc/st2/st2.docker.conf

        rsync -av /opt/stackstorm/packs/ /tmp/shared/packs
        st2ctl reload
        EOF
        ]

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
            name       = "stackstorm-packs-configs"
            mount_path = "/opt/stackstorm/configs"
          },
          {
            name       = "stackstorm-packs"
            mount_path = "/tmp/shared/packs"
          },
          {
            name       = "config-chatbot-aliases"
            mount_path = "/opt/stackstorm/packs/chatbot/aliases"
          },
        ]
      },
    ]

    restart_policy = "OnFailure"

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


module "job" {
  source     = "../../../archetypes/job"
  parameters = merge(local.parameters, var.overrides)
}
