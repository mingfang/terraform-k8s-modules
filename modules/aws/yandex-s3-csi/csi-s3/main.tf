locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations

    containers = [
      {
        name  = "driver-registrar"
        image = var.registrar_image
        args  = [
          "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)",
          "--v=4",
          "--csi-address=$(ADDRESS)",
        ]
        env = [
          {
            name= "ADDRESS"
            value= "/csi/csi.sock"
          },
          {
            name = "DRIVER_REG_SOCK_PATH"
            value="/var/lib/kubelet/plugins/ru.yandex.s3.csi/csi.sock"
          },
          {
            name       = "KUBE_NODE_NAME"
            value_from = {
              field_ref = {
                field_path = "spec.nodeName"
              }
            }
          },
        ]
        volume_mounts = [
          {
            name = "plugin-dir"
            mount_path = "/csi"
          },
          {
            name = "registration-dir"
            mount_path = "/registration/"
          }
        ]
      },
      {
        name    = "csi-s3"
        image   = var.image
        command = var.command
        args    = [
          "--endpoint=$(CSI_ENDPOINT)",
          "--nodeid=$(NODE_ID)",
          "--v=4",
        ]

        env = concat([
          {
            name = "CSI_ENDPOINT"
            value = "unix:///csi/csi.sock"
          },
          {
            name       = "NODE_ID"
            value_from = {
              field_ref = {
                field_path = "spec.nodeName"
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

        security_context = {
          privileged   = true
          capabilities = {
            add = [
              "SYS_ADMIN"
            ]
          }
          allow_privilege_escalation : true
        }

        volume_mounts = [
          {
            name       = "plugin-dir"
            mount_path = "/csi"
          },
          {
            name              = "pods-mount-dir"
            mount_path        = "/var/lib/kubelet/pods"
            mount_propagation = "Bidirectional"
          }, {
            name       = "fuse-device"
            mount_path = "/dev/fuse"
          }
        ]
      },
    ]

    host_network         = true
    image_pull_secrets   = var.image_pull_secrets
    node_selector        = var.node_selector
    service_account_name = module.rbac.service_account_name

    volumes = [
      {
        name      = "registration-dir"
        host_path = {
          path = "/var/lib/kubelet/plugins_registry/"
          type = "DirectoryOrCreate"
        }
      },
      {
        name      = "plugin-dir"
        host_path = {
          path = "/var/lib/kubelet/plugins/ru.yandex.s3.csi"
          type = "DirectoryOrCreate"
        }
      },
      {
        name      = "pods-mount-dir"
        host_path = {
          path = "/var/lib/kubelet/pods"
          type = "Directory"
        }
      },
      {
        name      = "fuse-device"
        host_path = {
          path = "/dev/fuse"
        }
      }
    ]
  }
}

module "daemonset" {
  source     = "../../../../archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}