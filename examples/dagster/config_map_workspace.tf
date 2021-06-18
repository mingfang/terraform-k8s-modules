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
          host: z1
          port: 3030
          location_name: z1
    EOF
  }
}