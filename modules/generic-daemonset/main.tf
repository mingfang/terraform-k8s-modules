locals {
  input_env = merge(
    var.env_file != null ? { for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1] } : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

module "config_files" {
  count      = var.config_files != null ? 1 : 0
  source     = "../kubernetes/config-map"
  name       = "${var.name}-config-files"
  namespace  = var.namespace
  from-files = var.config_files
}

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace

    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    containers = concat([
      {
        name    = var.name
        image   = var.image
        command = var.command
        args    = var.args

        image_pull_policy = var.image_pull_policy

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
            name = "POD_NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name = "POD_IP"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name = "LIMITS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "limits.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name = "REQUESTS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "requests.memory"
                divisor  = "1Mi"
              }
            }
          },
        ], var.env, local.computed_env)

        env_from = var.env_from

        liveness_probe  = var.liveness_probe
        readiness_probe = var.readiness_probe
        startup_probe   = var.startup_probe

        lifecycle = var._lifecycle != null ? var._lifecycle : (var.post_start_command != null ? {
          post_start = {
            exec = {
              command = var.post_start_command
            }
          }
        } : null)

        resources        = var.resources
        security_context = var.security_context

        volume_mounts = concat(
          [
            for pvc in var.pvcs :
            {
              name       = pvc.name
              mount_path = pvc.mount_path
            }
          ],
          [
            for volume in var.volumes :
            {
              name       = volume.name
              mount_path = volume.mount_path
            }
          ],
          var.configmap != null ? [
            for k, v in var.configmap.data :
            {
              name       = "config"
              mount_path = "${var.configmap_mount_path}/${k}"
              sub_path   = k
            }
          ] : [],
          var.config_files != null ? [
            for k, v in module.config_files[0].config_map.data :
            {
              name       = "config-files"
              mount_path = "${var.config_files_mount_path}/${k}"
              sub_path   = k
            }
          ] : [],
        )
      },
    ], var.sidecars)

    init_containers = concat(
      length(var.pvcs) > 0 && length(var.pvc_user) > 0 ? [
        {
          name  = "init"
          image = var.image

          command = concat(
            [
              "sh",
              "-cx",
              join(" &&", [for pvc in var.pvcs : "chown ${var.pvc_user} ${pvc.mount_path} || true"])
            ],
          )

          security_context = {
            run_asuser = "0"
          }

          volume_mounts = concat(
            [
              for pvc in var.pvcs :
              {
                name       = pvc.name
                mount_path = pvc.mount_path
              }
            ],
            [
              for volume in var.volumes :
              {
                name       = volume.name
                mount_path = volume.mount_path
              }
            ],
            var.configmap != null ? [
              for k, v in var.configmap.data :
              {
                name       = "config"
                mount_path = "${var.configmap_mount_path}/${k}"
                sub_path   = k
              }
            ] : [],
          )
        },
      ] : [],
      var.init_containers,
    )

    volumes = concat(
      [
        for pvc in var.pvcs :
        {
          name = pvc.name
          persistent_volume_claim = {
            claim_name = pvc.name
          }
        }
      ],
      [for volume in var.volumes : volume],
      var.configmap != null ? [
        {
          name = "config"
          config_map = {
            name = var.configmap.metadata[0].name
          }
        }
      ] : [],
      var.config_files != null ? [
        {
          name = "config-files"
          config_map = {
            name = module.config_files[0].config_map.metadata[0].name
          }
        }
      ] : [],
    )

    dns_config                       = var.dns_config
    dns_policy                       = var.dns_policy
    enable_service_links             = false
    host_ipc                         = var.host_ipc
    host_network                     = var.host_network
    host_pid                         = var.host_pid
    image_pull_secrets               = var.image_pull_secrets
    node_selector                    = var.node_selector
    service_account_name             = local.use_RBAC ? module.rbac.0.service_account_name : var.service_account_name
    termination_grace_period_seconds = var.termination_grace_period_seconds
    tolerations                      = var.tolerations
  }
}

module "daemonset" {
  source     = "../../archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
