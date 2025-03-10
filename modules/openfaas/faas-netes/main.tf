locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name    = "faas-netes"
        image   = var.image
        command = ["./faas-netes", "-operator=${var.operator}"]

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
            name  = "port"
            value = var.ports[0].port
          },
          {
            name  = "function_namespace"
            value = coalesce(var.function_namespace, var.namespace)
          },
          {
            name  = "read_timeout"
            value = var.read_timeout
          },
          {
            name  = "write_timeout"
            value = var.write_timeout
          },
          {
            name  = "image_pull_policy"
            value = var.image_pull_policy
          },
          {
            name  = "http_probe"
            value = var.http_probe
          },
          {
            name  = "set_nonroot_user"
            value = var.set_nonroot_user
          },
          {
            name  = "readiness_probe_initial_delay_seconds"
            value = var.readiness_probe_initial_delay_seconds
          },
          {
            name  = "readiness_probe_timeout_seconds"
            value = var.readiness_probe_timeout_seconds
          },
          {
            name  = "readiness_probe_period_seconds"
            value = var.readiness_probe_period_seconds
          },
          {
            name  = "liveness_probe_initial_delay_seconds"
            value = var.liveness_probe_initial_delay_seconds
          },
          {
            name  = "liveness_probe_timeout_seconds"
            value = var.liveness_probe_timeout_seconds
          },
          {
            name  = "liveness_probe_period_seconds"
            value = var.liveness_probe_period_seconds
          },
        ], var.env)

        liveness_probe = {
          http_get = {
            path = "/healthz"
            port = 8080
          }
        }
        readiness_probe = {
          http_get = {
            path = "/healthz"
            port = 8080
          }
        }

        resources = var.resources

        security_context = {
          read_only_root_filesystem = true
          run_asuser                = 10001
        }
      },
    ]
    service_account_name = module.rbac.name
  }

  podAnnotations = {
    "prometheus.io.scrape" = "true"
    "prometheus.io.port"   = "8080"
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
  //  podAnnotations = local.podAnnotations
}