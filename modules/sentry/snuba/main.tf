locals {
  env = concat([
    {
      name  = "SNUBA_SETTINGS"
      value = var.SNUBA_SETTINGS
    },
    {
      name  = "CLICKHOUSE_HOST"
      value = var.CLICKHOUSE_HOST
    },
    {
      name  = "DEFAULT_BROKERS"
      value = var.DEFAULT_BROKERS
    },
    {
      name  = "REDIS_HOST"
      value = var.REDIS_HOST
    },
    {
      name  = "UWSGI_MAX_REQUESTS"
      value = "10000"
    },
    {
      name  = "UWSGI_DISABLE_LOGGING"
      value = "true"
    },
  ], var.env)

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name  = "snuba"
        image = var.image
        env   = local.env

        lifecycle = {
          post_start = {
            exec = {
              command = [
                "sh",
                "-cx",
                <<-EOF
                snuba bootstrap --force || true
                EOF
              ]
            }
          }
        }

        liveness_probe = {
          http_get = {
            path = "/health"
            port = 1218
          }
        }
      },
      {
        name  = "events"
        image = var.image
        env   = local.env
        command = [
          "sh",
          "-cx",
          <<-EOF
          /usr/src/snuba/bin/consumer --dataset events --auto-offset-reset=latest --max-batch-time-ms 750
          EOF
        ]
      },
      {
        name  = "outcomes"
        image = var.image
        env   = local.env
        command = [
          "sh",
          "-cx",
          <<-EOF
          /usr/src/snuba/bin/consumer --dataset outcomes --auto-offset-reset=earliest --max-batch-time-ms 750
          EOF
        ]
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
