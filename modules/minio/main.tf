/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = [
      {
        name = "http"
        port = 9000
      },
    ]

    containers = [
      {
        args = concat([
          "server",
        ], data.template_file.this.*.rendered)
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
            name  = "MINIO_ACCESS_KEY"
            value = var.minio_access_key
          },
          {
            name  = "MINIO_SECRET_KEY"
            value = var.minio_secret_key
          },
        ], var.env)

        image = var.image
        name  = "minio"

        volume_mounts = [
          {
            name = var.volume_claim_template_name
            mount_path = "/data"
            sub_path = var.name
          }
        ]
      },
    ]

    volume_claim_templates = [
      {
        name = var.volume_claim_template_name
        storage_class_name = var.storage_class_name
        access_modes = ["ReadWriteOnce"]

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

data "template_file" "this" {
  count = var.replicas
  template = "http://${var.name}-${count.index}.${var.name}.${var.namespace}.svc.cluster.local/data/${var.name}-${count.index}"
}
