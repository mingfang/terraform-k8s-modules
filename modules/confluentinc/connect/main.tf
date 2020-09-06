locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports

    enable_service_links  = false

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
            name = "CONNECT_SCHEMA_REGISTRY_URL"
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
            name = "CONNECT_KEY_CONVERTER"
            value = var.CONNECT_KEY_CONVERTER
          },
          {
            name = "CONNECT_VALUE_CONVERTER"
            value = var.CONNECT_VALUE_CONVERTER
          },
          {
            name = "CONNECT_CONFIG_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}.config"
          },
          {
            name = "CONNECT_OFFSET_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}.offset"
          },
          {
            name = "CONNECT_STATUS_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}.status"
          },
          {
            name = "CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR"
            value = var.CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR
          },
          {
            name = "CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR"
            value = var.CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR
          },
          {
            name = "CONNECT_STATUS_STORAGE_REPLICATION_FACTOR"
            value = var.CONNECT_STATUS_STORAGE_REPLICATION_FACTOR
          },
          {
            name = "CONNECT_PLUGIN_PATH"
            value = var.CONNECT_PLUGIN_PATH
          }
        ], var.env)

        liveness_probe = {
          failure_threshold = 3

          http_get = {
            path   = "/"
            port   = var.ports.0.port
            scheme = "HTTP"
          }
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
