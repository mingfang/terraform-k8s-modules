locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "coordinator"
        image = var.image
        args = concat([
          "arangod",
          "--cluster.my-address=tcp://$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:${var.ports[0].port}",
          "--cluster.my-role=COORDINATOR",
          "--server.endpoint=tcp://0.0.0.0:${var.ports[0].port}",
          "--server.jwt-secret-keyfile=/dev/shm/jwt-secret-keyfile",
        ], var.cluster-agency-endpoints)

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
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name = "jwt-secret-keyfile"
            mount_path = "/dev/shm/jwt-secret-keyfile"
            sub_path = "jwt-secret-file"
          }
        ]
      },
    ]
    volumes = [
      {
        name = "jwt-secret-keyfile"
        secret = {
          secret_name = var.jwt-secret-keyfile
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}