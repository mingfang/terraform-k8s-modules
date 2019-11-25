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

    // restart on config change
    annotations = merge(var.annotations, { checksum = md5(data.template_file.config.rendered) })

    containers = [
      {
        name  = "server"
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
            name = "RINGPOP_SEEDS"
            value = coalesce(
              var.RINGPOP_SEEDS,
              join(",", [
                "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local:7933",
                "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local:7934",
                "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local:7935",
                "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local:7939",
              ])
            )
          },
          {
            name  = "RINGPOP_BOOTSTRAP_MODE"
            value = "dns"
          },
          {
            name  = "CASSANDRA_SEEDS"
            value = var.CASSANDRA_SEEDS
          },
          {
            name  = "CASSANDRA_CONSISTENCY"
            value = "Quorum"
          },
          {
            name  = "BIND_ON_IP"
            value = "$(POD_IP)"
          },
          {
            name  = "CADENCE_CLI_ADDRESS"
            value = "$(POD_IP):7933"
          },
          {
            name  = "CADENCE_CLI_DOMAIN"
            value = var.CADENCE_CLI_DOMAIN
          },
          {
            name  = "LOG_LEVEL"
            value = var.LOG_LEVEL
          },
          {
            name  = "NUM_HISTORY_SHARDS"
            value = var.NUM_HISTORY_SHARDS
          },
          {
            name  = "STATSD_ENDPOINT"
            value = var.STATSD_ENDPOINT
          },
          {
            name  = "SERVICES"
            value = var.SERVICES
          },
          {
            name  = "SKIP_SCHEMA_SETUP"
            value = var.SKIP_SCHEMA_SETUP
          },
        ], var.env)

        /*
        Auto register domain
        */
        lifecycle = var.SKIP_SCHEMA_SETUP ? null : {
          post_start = {
            exec = {
              command = [
                "bash",
                "-cx",
                <<-EOF
                export CADENCE_CLI_ADDRESS="$POD_IP:7933"
                until cadence --domain $CADENCE_CLI_DOMAIN domain describe || (cadence --domain $CADENCE_CLI_DOMAIN domain describe|grep EntityNotExistsError && cadence --domain $CADENCE_CLI_DOMAIN domain register); do
                  sleep 3
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

        liveness_probe = var.SKIP_SCHEMA_SETUP ? null : {
          initial_delay_seconds = 300
          period_seconds        = 60

          exec = {
            command = [
              "bash",
              "-cx",
              <<-EOF
              export CADENCE_CLI_ADDRESS="$POD_IP:7933"
              cadence --domain $CADENCE_CLI_DOMAIN domain describe || cadence --domain $CADENCE_CLI_DOMAIN domain describe|grep EntityNotExistsError
              EOF
            ]
          }
        }

        readiness_probe = var.SKIP_SCHEMA_SETUP ? null : {
          initial_delay_seconds = 5

          exec = {
            command = [
              "bash",
              "-cx",
              <<-EOF
              export CADENCE_CLI_ADDRESS="$POD_IP:7933"
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
      },
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
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}