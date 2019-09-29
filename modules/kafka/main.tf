locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "kafka"
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
            name  = "KAFKA_LOG_DIRS"
            value = "/data/$(POD_NAME)"
          },
          {
            name  = "KAFKA_ADVERTISED_LISTENERS"
            value = "PLAINTEXT://$(POD_NAME).${var.name}.${var.namespace == null ? "default" : var.namespace}.svc.cluster.local:9092"
          },
          {
            name  = "KAFKA_ZOOKEEPER_CONNECT"
            value = var.kafka_zookeeper_connect
          },
        ], var.env)

        liveness_probe = {
          initial_delay_seconds = 1
          timeout_seconds       = 3

          exec = {
            command = [
              "sh",
              "-ec",
              "/usr/bin/jps | /bin/grep -q SupportedKafka",
            ]
          }
        }

        readiness_probe = {
          tcp_socket = {
            port = var.ports.0.port
          }
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          },
        ]
      },
    ]
    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class_name
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
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
