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
        name  = "gateway"
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
            name  = "read_timeout"
            value = var.read_timeout
          },
          {
            name  = "write_timeout"
            value = var.write_timeout
          },
          {
            name  = "upstream_timeout"
            value = var.upstream_timeout
          },
          {
            name  = "functions_provider_url"
            value = var.functions_provider_url
          },
          {
            name  = "direct_functions"
            value = var.direct_functions
          },
          {
            name  = "function_namespace"
            value = coalesce(var.function_namespace, var.namespace)
          },
          {
            name  = "direct_functions_suffix"
            value = "${coalesce(var.function_namespace, var.namespace)}.svc.cluster.local"
          },
          {
            name  = "faas_nats_address"
            value = var.faas_nats_address
          },
          {
            name  = "faas_nats_port"
            value = var.faas_nats_port
          },
          {
            name  = "faas_nats_cluster_name"
            value = var.faas_nats_cluster_name
          },
          {
            name  = "faas_nats_channel"
            value = var.faas_nats_channel
          },
          {
            name  = "scale_from_zero"
            value = var.scale_from_zero
          },
          {
            name  = "max_idle_conns"
            value = var.max_idle_conns
          },
          {
            name  = "max_idle_conns_per_host"
            value = var.max_idle_conns_per_host
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
    "prometheus.io.port"   = "8082"
  }
}

module "deployment-service" {
  source         = "../../../archetypes/deployment-service"
  parameters     = merge(local.parameters, var.overrides)
  podAnnotations = local.podAnnotations
}