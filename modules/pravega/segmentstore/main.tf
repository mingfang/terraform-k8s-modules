locals {
  input_env = merge(
    var.env_file != null ? { for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1] } : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "segmentstore"
        image = var.image

        args = ["segmentstore"]

        env = concat([
          {
            name       = "POD_NAME"
            value_from = { field_ref = { field_path = "metadata.name" } }
          },
          {
            name       = "POD_NAMESPACE"
            value_from = { field_ref = { field_path = "metadata.namespace" } }
          },
          {
            name  = "ZK_URL"
            value = var.ZK_URL
          },
          {
            name  = "CONTROLLER_URL"
            value = var.CONTROLLER_URL
          },
          {
            name  = "JAVA_OPTS"
            value = <<-EOF
            -Dpravegaservice.service.published.host.nameOrIp=$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local
            -Dbookkeeper.ensemble.size=2
            -Dbookkeeper.ack.quorum.size=2
            -Dbookkeeper.write.quorum.size=2
            -XX:OnError="kill -9 p%"
            -XX:+ExitOnOutOfMemoryError
            -XX:+CrashOnOutOfMemoryError
            -XX:+HeapDumpOnOutOfMemoryError
            ${var.JAVA_OPTS}
            EOF
          },
        ], var.env, local.computed_env)

        resources = var.resources
      },
    ]
    node_selector        = var.node_selector
    service_account_name = var.service_account_name
  }
}


module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}