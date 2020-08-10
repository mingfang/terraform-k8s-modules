locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports

    enable_service_links  = false
    strategy = {
      type = "Recreate"
    }

    containers = [
      {
        name  = "ksqldb-server"
        image = var.image
        env = concat([
          {
            name  = "KSQL_BOOTSTRAP_SERVERS"
            value = var.KSQL_BOOTSTRAP_SERVERS
          },
          {
            name  = "KSQL_KSQL_SERVICE_ID"
            value = "${var.name}-${var.namespace}"
          },
          {
            name = "KSQL_LISTENERS"
            value = "http://0.0.0.0:${var.ports[0].port}"
          },
          {
            name = "KSQL_KSQL_SCHEMA_REGISTRY_URL"
            value = var.KSQL_KSQL_SCHEMA_REGISTRY_URL
          },
          {
            name  = "KSQL_CONNECT_BOOTSTRAP_SERVERS"
            value = var.KSQL_BOOTSTRAP_SERVERS
          },
          {
            name  = "KSQL_CONNECT_GROUP_ID"
            value = "${var.name}-${var.namespace}"
          },
          {
            name  = "KSQL_CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL"
            value = var.KSQL_KSQL_SCHEMA_REGISTRY_URL
          },
          {
            name  = "KSQL_CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL"
            value = var.KSQL_KSQL_SCHEMA_REGISTRY_URL
          },
          {
            name = "KSQL_CONNECT_KEY_CONVERTER"
            value = var.KSQL_CONNECT_KEY_CONVERTER
          },
          {
            name = "KSQL_CONNECT_VALUE_CONVERTER"
            value = var.KSQL_CONNECT_VALUE_CONVERTER
          },
          {
            name = "KSQL_CONNECT_CONFIG_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}-${var.KSQL_CONNECT_CONFIG_STORAGE_TOPIC}"
          },
          {
            name = "KSQL_CONNECT_OFFSET_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}-${var.KSQL_CONNECT_OFFSET_STORAGE_TOPIC}"
          },
          {
            name = "KSQL_CONNECT_STATUS_STORAGE_TOPIC"
            value = "${var.name}-${var.namespace}-${var.KSQL_CONNECT_STATUS_STORAGE_TOPIC}"
          },
          {
            name = "KSQL_CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR"
            value = var.KSQL_CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR
          },
          {
            name = "KSQL_CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR"
            value = var.KSQL_CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR
          },
          {
            name = "KSQL_CONNECT_STATUS_STORAGE_REPLICATION_FACTOR"
            value = var.KSQL_CONNECT_STATUS_STORAGE_REPLICATION_FACTOR
          },
          {
            name = "KSQL_CONNECT_PLUGIN_PATH"
            value = var.KSQL_CONNECT_PLUGIN_PATH
          }
        ], var.env)
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
