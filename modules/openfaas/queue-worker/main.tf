locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "queue-worker"
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
            name  = "faas_nats_queue_group"
            value = var.faas_nats_queue_group
          },
          {
            name  = "faas_gateway_address"
            value = var.faas_gateway_address
          },
          {
            name  = "gateway_invoke"
            value = var.gateway_invoke
          },
          {
            name  = "faas_function_suffix"
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
            name  = "max_inflight"
            value = var.max_inflight
          },
          {
            name  = "ack_wait"
            value = var.ack_wait
          },
        ], var.env)

        resources = var.resources
      },
    ]
  }
}


module "deployment-service" {
  source         = "../../../archetypes/deployment-service"
  parameters     = merge(local.parameters, var.overrides)
}