resource "k8s_core_v1_persistent_volume_claim" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = { "storage" = "1Gi" }
    }

    storage_class_name = module.storage-class.name
  }
}

locals {
  parameters = {
    name      = "nginx"
    namespace = var.namespace
    node_name = "skull3"
    ports = [
      {
        name = "http"
        port = 80
      }
    ]
    containers = [
      {
        image             = "nginx"
        image_pull_policy = "Always"
        name              = "nginx"


        volume_mounts = [
          {
            mount_path = "/var/www"
            name       = "alluxio"
          }
        ]
      }
    ]
    volumes = [
      {
        name = "alluxio"
        persistent_volume_claim = {
          claim_name = k8s_core_v1_persistent_volume_claim.this.metadata[0].name
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../archetypes/deployment-service"
  parameters = local.parameters
}
