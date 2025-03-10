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
        name  = "controller"
        image = var.image

        args = ["controller"]

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
            name  = "SERVICE_HOST_IP"
            value = var.SERVICE_HOST_IP
          },
          {
            name  = "REST_SERVER_PORT"
            value = var.ports[0].port
          },
          {
            name  = "JAVA_OPTS"
            value = <<-EOF
            -Dpravegaservice.zk.connect.uri=${var.ZK_URL}
            -Dcli.controller.connect.rest.uri=localhost:${var.ports[0].port}
            -Dbookkeeper.ledger.path=/pravega/pravega-cluster/bookkeeper/ledgers
            -Dcontroller.service.rpc.listener.port=${var.ports[1].port}
            -Xmx512m
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