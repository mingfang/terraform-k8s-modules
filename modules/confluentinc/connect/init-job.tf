locals {
  plugin_commands = join("\n", [
  for plugin in var.plugins :
  "confluent-hub install --no-prompt --component-dir ${var.CONNECT_PLUGIN_PATH} ${plugin}"
  ])

  connector_commands = var.configmap != null ? join("\n", [
  for k, v in var.configmap.data :
  "cat /tmp/connectors/${k} && curl -s -S -d @\"/tmp/connectors/${k}\" -H \"Content-Type: application/json\"  -X POST http://${var.name}:${var.ports[0].port}/connectors"
  ]) : ""
}

module "init-job" {
  source    = "../../kubernetes/job"
  name      = "${var.name}-init"
  namespace = var.namespace
  image     = var.image

  command = [
    "bash",
    "-c",
    <<-EOF
    set -e
    until curl -s http://${var.name}:${var.ports[0].port}; do
      echo "Waiting for http://${var.name}:${var.ports[0].port}..."
      sleep 10
    done

    echo "Installing plugins..."
    ${local.plugin_commands}

    echo "Creating connectors..."
    ${local.connector_commands}
    EOF
  ]

  volume_mounts = concat(
    var.pvc != null ? [
      {
        name       = "data"
        mount_path = var.CONNECT_PLUGIN_PATH
      },
    ] : [],
    var.configmap != null ? [
      {
        name       = "config"
        mount_path = "/tmp/connectors"
      }
    ] : [],
  )

  volumes = concat(
    var.pvc != null ? [
      {
        name = "data"

        persistent_volume_claim = {
          claim_name = var.pvc
        }
      }
    ] : [],
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
