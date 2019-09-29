/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    labels               = local.labels
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "nifi"
        image = var.image
        env = concat([
          {
            name  = "NIFI_ELECTION_MAX_WAIT"
            value = "30 secs"
          },
          {
            name  = "NIFI_CLUSTER_NODE_PROTOCOL_PORT"
            value = "1025"
          },
          {
            name = "NIFI_CLUSTER_ADDRESS"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name = "NIFI_WEB_HTTP_HOST"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "NIFI_WEB_HTTP_PORT"
            value = var.ports.0.port
          },
        ], var.env)
        security_context = {
          run_asuser = "0"
        }
      },
    ]
  }
}

module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}