locals {
  input_env = merge(
    var.env_file != null ? { for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1] } : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links = false

    containers = [
      {
        name  = var.name
        image = var.image
        command = [
          "sh",
          "-c",
          <<-EOF
          cd /root/${var.scope-name}
          # update scope name
          test -f scope.json && sed -ie 's|"name": ".*"|"name": "${var.scope-name}"|' scope.json
          # init scope if missing
          test -f scope.json || bit init --bare
          exec bit start
          EOF
        ]

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

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/root/${var.scope-name}"
          },
        ] : []
      },
    ]

    node_selector        = var.node_selector
    service_account_name = var.service_account_name

    volumes = var.pvc != null ? [
      {
        name = "data"

        persistent_volume_claim = {
          claim_name = var.pvc
        }
      }
    ] : []
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}