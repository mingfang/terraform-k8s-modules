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

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

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
        security_context = var.security_context

        volume_mounts = concat(
          var.storage != null ? [
            {
              name       = var.volume_claim_template_name
              mount_path = var.mount_path
            },
          ] : [],
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
    ], var.sidecars)

    init_containers = concat(
      var.storage != null ? [
        {
          name  = "init1"
          image = var.image

          command = [
            "sh",
            "-cx",
            <<-EOF
            chown ${var.pvc_user} ${var.mount_path} || true
            EOF
          ]

          security_context = {
            run_asuser = "0"
          }

          volume_mounts = [
            {
              name       = var.volume_claim_template_name
              mount_path = var.mount_path
            },
          ]
        },
      ] : [],
      length(var.pvcs) > 0 && length(var.pvc_user) > 0 ? [
        {
          name  = "init2"
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

          volume_mounts = [
            for pvc in var.pvcs :
            {
              name       = pvc.name
              mount_path = pvc.mount_path
            }
          ]
        },
      ] : []
    )

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

    tolerations = var.tolerations

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

    volume_claim_templates = var.storage != null ? [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}