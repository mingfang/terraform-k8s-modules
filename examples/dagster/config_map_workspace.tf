module "config_map_workspace" {
  source    = "../../modules/kubernetes/config-map"
  name      = "${var.name}-workspace"
  namespace = var.namespace

  from-map = {
    "workspace.yaml" = <<-EOF
    load_from:
    - grpc_server:
        host: ${module.example-user-code.name}
        port: ${module.example-user-code.ports[0].port}
        location_name: ${module.example-user-code.name}
    - grpc_server:
        host: ${module.dagster-dbt.name}
        port: ${module.dagster-dbt.ports[0].port}
        location_name: ${module.dagster-dbt.name}
    EOF
  }
}