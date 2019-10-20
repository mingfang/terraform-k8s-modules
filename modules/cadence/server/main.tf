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
            name = "CASSANDRA_SEEDS"
            value = var.CASSANDRA_SEEDS
          },
          {
            name = "BIND_ON_IP"
            value = var.BIND_ON_IP
          },
          {
            name = "CADENCE_CLI_DOMAIN"
            value = var.CADENCE_CLI_DOMAIN
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

      }
    ]
  }
}

module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}