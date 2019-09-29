/**
 * [Docker Registry](https://docs.docker.com/registry/)
 *
 */

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "registry"
        image = var.image
        env   = var.env

        volume_mounts = [
          {
            mount_path = "/var/lib/registry"
            name       = var.volume_claim_template_name
            sub_path   = var.name
          },
        ]
      },
    ]
    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class_name
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ]
  }
}


module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
