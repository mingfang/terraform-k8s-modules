locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
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

    containers = [
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
          {
            name = "METASRV_LOG_DIR"
            value = "${var.mount_path}/log"
          },
          {
            name = "KVSRV_RAFT_DIR"
            value = "${var.mount_path}/raft"
          },
          {
            name = "ADMIN_API_ADDRESS"
            value = "$(POD_IP):28002"
          },
          {
            name = "METASRV_GRPC_API_ADDRESS"
            value = "$(POD_IP):9191"
          },
          {
            name = "KVSRV_API_PORT"
            value = "28004"
          },
          {
            name = "KVSRV_LISTEN_HOST"
            value = "$(POD_IP)"
          },
          {
            name = "KVSRV_ADVERTISE_HOST"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name = "KVSRV_ID"
            value = "1"
          },
          {
            name = "CLUSTER_NAME"
            value = var.namespace
          },
        ], var.env, local.computed_env)

        env_from = var.env_from

        resources = var.resources

        volume_mounts = concat(
          var.storage != null ? [
            {
              name       = var.volume_claim_template_name
              mount_path = var.mount_path
            },
          ] : [],
          var.configmap != null ? [
          for k, v in var.configmap.data :
          {
            name       = "config"
            mount_path = "/config/${var.name}/${k}"
            sub_path   = k
          }
          ] : [],
          [], //hack: without this, sub_path above stops working
        )
      },
    ]

    init_containers = var.storage != null ? [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          "chown 1000 ${var.mount_path}"
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
      }
    ] : []

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

    node_selector        = var.node_selector
    service_account_name = var.service_account_name

    volumes = var.configmap != null ? [
      {
        name = "config"

        config_map = {
          name = var.configmap.metadata[0].name
        }
      }
    ] : []

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
    ] : [],
  }
}

module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}