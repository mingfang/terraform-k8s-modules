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

    containers = [
      {
        name  = "cassandra"
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
            name  = "CASSANDRA_SEEDS"
            value = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
          },
          {
            name  = "CASSANDRA_START_RPC"
            value = "true"
          },
        ], var.env)

        command = [
          "sh",
          "-cx",
          <<-EOF
          #set data dir
          DIR="/data/$POD_NAME"
          mkdir -p $DIR
          chown -R cassandra:cassandra $DIR
          sed -ie "s|/var/lib/cassandra/data|$DIR|" /etc/cassandra/cassandra.yaml

          #enable node restart after IP change
          if [ ! -f $DIR/address ]; then
            echo "$POD_IP" > $DIR/address
          fi
          ADDRESS="$(cat $DIR/address)"
          if [[ $ADDRESS != $POD_IP ]]; then
            echo "replace_address_first_boot: $ADDRESS" >> /etc/cassandra/cassandra.yaml
            echo "$POD_IP" > $DIR/address
          fi

          /docker-entrypoint.sh
          EOF
        ]

        liveness_probe = {
          initial_delay_seconds = 300

          exec = {
            command = [
              "bash",
              "-cx",
              <<-EOF
              if [[ $(nodetool status | grep $POD_IP) == *"UN"* ]]; then
                  exit 0
              else
                  exit 1
              fi
              EOF
            ]
          }
        }

        readiness_probe = {
          initial_delay_seconds = 10

          exec = {
            command = [
              "bash",
              "-cx",
              <<-EOF
              if [[ $(nodetool status | grep $POD_IP) == *"UN"* ]]; then
                  exit 0
              else
                  exit 1
              fi
              EOF
            ]
          }
        }

        resources = {
          requests = {
            cpu    = "500m"
            memory = "1Gi"
          }
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          }
        ]
      },
    ]

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