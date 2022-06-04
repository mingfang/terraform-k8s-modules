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
    replicas  = 1
    ports     = var.ports
    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    enable_service_links = false

    containers = [
      {
        name    = "postgres"
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
            name  = "POSTGRES_USER"
            value = var.POSTGRES_USER
          },
          {
            name  = "POSTGRES_PASSWORD"
            value = var.POSTGRES_PASSWORD
          },
          {
            name  = "POSTGRES_DB"
            value = var.POSTGRES_DB
          },
          {
            name  = "PGDATA"
            value = "/data"
          },
          {
            name  = "POSTGRES_PORT"
            value = var.ports[0].port
          },
        ], var.env, local.computed_env)

        resources = var.resources

        volume_mounts = concat(
          [
            {
              name       = var.volume_claim_template_name
              mount_path = "/data"
            },
            {
              name       = "shm"
              mount_path = "/dev/shm"
            },
          ],
          var.configmap != null ? [
            for k, v in var.configmap.data :
            {
              name       = "config"
              mount_path = "/docker-entrypoint-initdb.d/${k}"
              sub_path   = k
            }
          ] : [],
          [], //hack: without this, sub_path above stops working
        )
      },
    ]

    node_selector        = var.node_selector
    service_account_name = var.service_account_name

    volumes = concat(
      var.configmap != null ? [
        {
          name = "config"

          config_map = {
            name = var.configmap.metadata[0].name
          }
        }
      ] : [],
      [
        {
          name = "shm"

          empty_dir = {
            "medium" = "Memory"
          }
        },
      ],
    )

    volume_claim_templates = [
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
    ]
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}