/**
 * Runs a NFS Server serving from an empheral empty dir.
 *
 * WARNING: For demonstration purpose only; You will loose data.
 *
 * Based on https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs
 */

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = 1
    ports = [
      {
        name = "tcp"
        port = var.port
      }
    ]
    containers = [
      {
        name  = "nfs-server"
        image = var.image

        env = [
          {
            name  = "SHARED_DIRECTORY"
            value = "/data"
          },
        ]

        security_context = {
          privileged = true
        }

        volume_mounts = [
          {
            mount_path = "/data"
            name       = "data"
          }
        ]
      }
    ]

    volumes = [
      {
        name = "data"

        empty_dir = {
          medium = var.medium
        }
      }
    ]
  }
}

locals {
  mount_options = [
    "nfsvers=4.2",
    "proto=tcp",
    "port=${var.port}",
  ]
}

module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
