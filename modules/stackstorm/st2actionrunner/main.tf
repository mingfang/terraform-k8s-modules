locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = concat([
      {
        name  = "st2actionrunner"
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
          {
            name       = "stackstorm-packs-configs"
            mount_path = "/opt/stackstorm/configs"
          },
          {
            name       = "stackstorm-packs"
            mount_path = "/opt/stackstorm/packs"
          },
          {
            name       = "stackstorm-virtualenvs"
            mount_path = "/opt/stackstorm/virtualenvs"
          },
          {
            name       = "stackstorm-ssh"
            mount_path = "/home/stanley.ssh"
          },
        ]
      }
    ], var.additional_containers)

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
          chown st2:st2 /opt/stackstorm/virtualenvs
          chown st2:st2 /home/stanley.ssh

          KEYPATH=/etc/st2/keys/datastore_key.json
          if [ ! -f "$${KEYPATH}" ]; then
            echo "Generating $${KEYPATH}"
            st2-generate-symmetric-crypto-key --key-path $${KEYPATH}
            chown -R st2:st2 /etc/st2/keys
            chmod -R 750 /etc/st2/keys
          fi
          EOF
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
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
          {
            name       = "stackstorm-virtualenvs"
            mount_path = "/opt/stackstorm/virtualenvs"
          },
          {
            name       = "stackstorm-ssh"
            mount_path = "/home/stanley.ssh"
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
      {
        name = "stackstorm-virtualenvs"
        persistent_volume_claim = {
          claim_name = var.stackstorm_virtualenvs_pvc_name
        }
      },
      {
        name = "stackstorm-ssh"
        persistent_volume_claim = {
          claim_name = var.stackstorm_ssh_pvc_name
        }
      },
    ]

  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
