/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    annotations = merge(
      var.annotations,
      {
        "config_checksum" = md5(join("", keys(k8s_core_v1_config_map.this.data), values(k8s_core_v1_config_map.this.data)))
      },
    )

    containers = [
      {
        name  = "obp"
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
            name  = "OBP_KAFKA_BOOTSTRAP_HOSTS"
            value = var.OBP_KAFKA_BOOTSTRAP_HOSTS
          },
          {
            name  = "OBP_KAFKA_CLIENT_ID"
            value = var.OBP_KAFKA_CLIENT_ID
          },
          {
            name  = "OBP_KAFKA_PARTITIONS"
            value = var.OBP_KAFKA_PARTITIONS
          },
          {
            name  = "OBP_KAFKA_REQUEST_TOPIC"
            value = var.OBP_KAFKA_REQUEST_TOPIC
          },
          {
            name  = "OBP_KAFKA_RESPONSE_TOPIC"
            value = var.OBP_KAFKA_RESPONSE_TOPIC
          },
          {
            name  = "OBP_CONNECTOR"
            value = var.OBP_CONNECTOR
          },
          {
            name  = "OBP_DB_DRIVER"
            value = var.OBP_DB_DRIVER
          },
          {
            name  = "OBP_DB_URL"
            value = var.OBP_DB_URL
          },
          {
            name  = "OBP_LOGGER_LOGLEVEL"
            value = var.OBP_LOGGER_LOGLEVEL
          },
          {
            name  = "OBP_AKKA_CONNECTOR_LOGLEVEL"
            value = var.OBP_AKKA_CONNECTOR_LOGLEVEL
          },
        ], var.env)

        command = [
          "sh",
          "-cx",
          <<-EOF
          export OBP_API_INSTANCE_ID="$(expr $${HOSTNAME//[^0-9]/} + 1)"
          exec java -jar start.jar
          EOF
        ]

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/jetty/resources/logback.xml"
            sub_path   = "logback.xml"
          },
        ]

      }
    ]

    volumes = [
      {
        config_map = {
          name = var.name
        }
        name = "config"
      },
    ]

  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
