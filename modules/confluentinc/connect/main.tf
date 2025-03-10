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
        name  = "connect"
        image = var.image

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
            name  = "CONNECT_SCHEMA_REGISTRY_URL"
            value = var.CONNECT_SCHEMA_REGISTRY_URL
          },
          {
            name  = "CONNECT_BOOTSTRAP_SERVERS"
            value = var.CONNECT_BOOTSTRAP_SERVERS
          },
          {
            name  = "CONNECT_REST_ADVERTISED_HOST_NAME"
            value = "$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "CONNECT_GROUP_ID"
            value = "${var.name}-${var.namespace}"
          },
          {
            name  = "CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL"
            value = var.CONNECT_SCHEMA_REGISTRY_URL
          },
          {
            name  = "CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL"
            value = var.CONNECT_SCHEMA_REGISTRY_URL
          },
          {
            name  = "CONNECT_KEY_CONVERTER"
            value = var.CONNECT_KEY_CONVERTER
          },
          {
            name  = "CONNECT_VALUE_CONVERTER"
            value = var.CONNECT_VALUE_CONVERTER
          },
          {
            name  = "CONNECT_CONFIG_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}.config"
          },
          {
            name  = "CONNECT_OFFSET_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}.offset"
          },
          {
            name  = "CONNECT_STATUS_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}.status"
          },
          {
            name  = "CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR"
            value = var.CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR
          },
          {
            name  = "CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR"
            value = var.CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR
          },
          {
            name  = "CONNECT_STATUS_STORAGE_REPLICATION_FACTOR"
            value = var.CONNECT_STATUS_STORAGE_REPLICATION_FACTOR
          },
          {
            name  = "CONNECT_PLUGIN_PATH"
            value = var.CONNECT_PLUGIN_PATH
          },
        ], var.env)

        liveness_probe = {
          failure_threshold = 3

          http_get = {
            path   = "/"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }

        resources = var.resources

        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = var.CONNECT_PLUGIN_PATH
          },
        ] : []
      },
    ]

    init_containers = var.pvc != null ? [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          "chown appuser ${var.CONNECT_PLUGIN_PATH}"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = var.CONNECT_PLUGIN_PATH
          },
        ]
      }
    ] : []

    node_selector = var.node_selector

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
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}