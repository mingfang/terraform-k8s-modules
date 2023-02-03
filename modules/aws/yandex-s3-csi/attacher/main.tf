locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  socket-dir  = "socket-dir"
  mount_path   = "/var/lib/kubelet/plugins/ru.yandex.s3.csi"
  csi_address = "${local.mount_path}/csi.sock"
}

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    annotations = var.annotations

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name    = "provisioner"
        image   = var.image
        command = var.command
        args    = [
          "--csi-address=${local.csi_address}",
          "--v=4",
        ]

        env = concat([
          {
            name       = "POD_NAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name       = "POD_IP"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
        ], var.env, local.computed_env)

        env_from = var.env_from

        lifecycle = var.post_start_command  != null ? {
          post_start = {
            exec = {
              command = var.post_start_command
            }
          }
        } : null

        resources = var.resources

        volume_mounts = [
          {
            name       = local.socket-dir
            mount_path = local.mount_path
          }
        ]
      },
    ]

    affinity = {
      pod_anti_affinity = {
        required_during_scheduling_ignored_during_execution = [
          {
            label_selector = {
              match_expressions = [
                {
                  key      = "name"
                  operator = "In"
                  values   = [var.name]
                }
              ]
            }
            topology_key = "kubernetes.io/hostname"
          }
        ]
      }
    }

    image_pull_secrets   = var.image_pull_secrets
    node_selector        = var.node_selector
    service_account_name = module.rbac.service_account_name

    volumes = [
      {
        name      = local.socket-dir
        host_path = {
          path = local.mount_path
          type = "DirectoryOrCreate"
        }
      },
    ]
  }
}

module "statefulset-service" {
  source     = "../../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}