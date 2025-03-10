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
      var.config_map != null ? {
        config_checksum = md5(join("", keys(var.config_map.data), values(var.config_map.data)))
      } : {},
    )

    enable_service_links = false

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
        ], var.env, local.computed_env)

        resources = var.resources

        volume_mounts = concat(
          var.pvc != null ? [
            {
              name       = "data"
              mount_path = "/data"
            },
          ] : [],
          var.config_map != null ? [
            for k, v in var.config_map.data :
            {
              name       = "config"
              mount_path = "/config/${k}"
              sub_path   = k
            }
          ] : [],
          var.policies_config_map != null ? [
            for k, v in var.policies_config_map.data :
            {
              name       = "policies"
              mount_path = "/policies/${k}"
              sub_path   = k
            }
          ] : [],
          var.schemas_config_map != null ? [
            for k, v in var.schemas_config_map.data :
            {
              name       = "schemas"
              mount_path = "/policies/_schemas/${k}"
              sub_path   = k
            }
          ] : [],
          [], //hack: without this, sub_path above stops working
        )
      },
    ]

    init_containers = var.pvc != null ? [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          "chown 1000 /data"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/data"
          },
        ]
      }
    ] : []

    node_selector        = var.node_selector
    service_account_name = var.service_account_name

    volumes = concat(
      var.pvc != null ? [
        {
          name = "data"

          persistent_volume_claim = {
            claim_name = var.pvc
          }
        }
      ] : [],
      var.config_map != null ? [
        {
          name = "config"

          config_map = {
            name = var.config_map.metadata[0].name
          }
        }
      ] : [],
      var.policies_config_map != null ? [
        {
          name = "policies"

          config_map = {
            name = var.policies_config_map.metadata[0].name
          }
        }
      ] : [],
      var.schemas_config_map != null ? [
        {
          name = "schemas"

          config_map = {
            name = var.schemas_config_map.metadata[0].name
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