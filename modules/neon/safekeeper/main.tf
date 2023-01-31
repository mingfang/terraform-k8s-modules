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
        name    = "safekeeper"
        image   = var.image
        command = [
          "bash",
          "-c",
          <<-EOF
          safekeeper \
          -D ${var.mount_path} \
          --id="$(expr $${HOSTNAME//[^0-9]/} + 1)" \
          --listen-pg="$${HOSTNAME}.${var.name}.${var.namespace}.svc.cluster.local:${var.ports.1.port}" \
          --listen-http='0.0.0.0:${var.ports.0.port}' \
          --broker-endpoint=$${BROKER_ENDPOINT} \
          --remote-storage="{endpoint='$${S3_ENDPOINT}', \
                              bucket_name='$${BUCKET_NAME}', \
                              bucket_region='$${BUCKET_REGION}', \
                              prefix_in_bucket='/$${BUCKET_PREFIX}/'}"
          EOF
        ]
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
            name = "BROKER_ENDPOINT"
            value = var.BROKER_ENDPOINT
          },
          {
            name = "S3_ENDPOINT"
            value = var.S3_ENDPOINT
          },
          {
            name = "BUCKET_NAME"
            value = var.BUCKET_NAME
          },
          {
            name = "BUCKET_REGION"
            value = var.BUCKET_REGION
          },
          {
            name = "BUCKET_PREFIX"
            value = var.BUCKET_PREFIX
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
              mount_path = "${var.configmap_mount_path}/${k}"
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
          "bash",
          "-c",
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