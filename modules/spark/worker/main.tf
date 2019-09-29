/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    enable_service_links = false
    containers = [
      {
        name  = "spark"
        image = var.image

        command = [
          "/spark/sbin/start-slave.sh",
          var.master_url,
        ]

        env = concat([
          {
            name = "SPARK_LOCAL_IP"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "SPARK_WORKER_WEBUI_PORT"
            value = var.spark_worker_webui_port
          },
        ], var.env)

        volume_mounts = lookup(var.overrides, "volume_mounts", [])
      }
    ]
  }
}


module "daemonset" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
