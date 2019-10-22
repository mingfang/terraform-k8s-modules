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
        name  = "server"
        image = var.image

        env = [
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "RINGPOP_SEEDS"
            value = join(",", [
              "${var.name}-0.${var.name}.${var.namespace}:7933",
              ])
          },
          {
            name = "RINGPOP_BOOTSTRAP_MODE"
            value = "dns"
          },
          {
            name = "CASSANDRA_SEEDS"
            value = var.CASSANDRA_SEEDS
          },
          {
            name = "CASSANDRA_CONSISTENCY"
            value = "Quorum"
          },
          {
            name = "BIND_ON_IP"
            value = var.BIND_ON_IP
          },
          {
            name = "CADENCE_CLI_DOMAIN"
            value = var.CADENCE_CLI_DOMAIN
          },
          {
            name = "LOG_LEVEL"
            value = var.LOG_LEVEL
          },
          {
            name = "NUM_HISTORY_SHARDS"
            value = var.NUM_HISTORY_SHARDS
          },
        ]

        /*
        Auto register domain
        */
        lifecycle = {
          post_start = {
            exec = {
              command = [
                "bash",
                "-cx",
                <<-EOF
                until cadence --domain $CADENCE_CLI_DOMAIN domain describe || (cadence --domain $CADENCE_CLI_DOMAIN domain describe|grep EntityNotExistsError && cadence --domain $CADENCE_CLI_DOMAIN domain register); do
                  sleep 10
                done
                EOF
              ]
            }
          }
        }

        /*
        EntityNotExistsError means that the cluster is able to talk to DB and verify that the domain is not registered.
        Which means that the cluster is OK.
        */

        liveness_probe = {
          initial_delay_seconds = 300
          period_seconds        = 60

          exec = {
            command = [
              "bash",
              "-cx",
              <<-EOF
              cadence --domain $CADENCE_CLI_DOMAIN domain describe || cadence --domain $CADENCE_CLI_DOMAIN domain describe|grep EntityNotExistsError
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
              cadence --domain $CADENCE_CLI_DOMAIN domain describe || cadence --domain $CADENCE_CLI_DOMAIN domain describe|grep EntityNotExistsError
              EOF
            ]
          }
        }

        volume_mounts = [
          {
            name       = "config"
            mount_path = "/etc/cadence/config/config_template.yaml"
            sub_path   = "config_template.yaml"
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
  source     = "git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}