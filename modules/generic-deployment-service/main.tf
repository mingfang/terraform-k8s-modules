locals {
  input_env = merge(
    var.env_file != null ? { for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1] } : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports     = var.ports

    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    enable_service_links = false

    containers = concat([
      {
        name    = var.name
        image   = var.image
        command = var.command
        args    = var.args

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
        ], var.env, local.computed_env)

        env_from = var.env_from

        lifecycle = var.post_start_command != null ? {
          post_start = {
            exec = {
              command = var.post_start_command
            }
          }
        } : null

        resources = var.resources

        volume_mounts = concat(
          var.pvcs,
          var.volumes,
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
    ], var.sidecars)

    init_containers = concat(length(var.pvcs) > 0 && length(var.pvc_user) > 0 ? [
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
          var.pvcs,
          var.volumes,
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
    ] : [], var.init_containers)

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
    service_account_name = local.use_RBAC ? module.rbac.0.service_account_name : var.service_account_name
    strategy             = var.strategy
    tolerations          = var.tolerations

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
    )
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
