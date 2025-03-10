locals {
  agency-endpoints = [
    for i in range(0, var.replicas) :
      "--agency.endpoint=tcp://${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:${var.ports[0].port}"
  ]
  cluster-agency-endpoints = [
    for i in range(0, var.replicas) :
      "--cluster.agency-endpoint=tcp://${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:${var.ports[0].port}"
  ]

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
        name  = "agency"
        image = var.image
        args = concat([
          "arangod",
          "--agency.my-address=tcp://$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:${var.ports[0].port}",
          "--agency.activate=true",
          "--agency.size=${var.replicas}",
          "--agency.supervision=true",
          "--javascript.app-path=/var/lib/arangodb3/arangodb3-apps",
          "--server.endpoint=tcp://0.0.0.0:${var.ports[0].port}",
          "--server.jwt-secret-keyfile=/dev/shm/jwt-secret-keyfile",
        ], local.agency-endpoints)

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
            name       = var.volume_claim_template_name
            mount_path = "/var/lib/arangodb3"
      },
          {
            name = "jwt-secret-keyfile"
            mount_path = "/dev/shm/jwt-secret-keyfile"
            sub_path = "jwt-secret-file"
          }
    ]
      },
    ]

    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
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

module "statefulset-service" {
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}