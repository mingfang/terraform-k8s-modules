locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports = [
      {
        name = "master"
        port = var.spark_master_port
      },
      {
        name = "http-webui"
        port = var.spark_master_webui_port
      },
    ]
    enable_service_links = false
    containers = [
      {
        name  = "spark"
        image = var.image
        command = [
          "/spark/sbin/start-master.sh"
        ]
        env = concat([
          {
            name = "SPARK_MASTER_HOST"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "SPARK_MASTER_PORT"
            value = var.spark_master_port
          },
          {
            name  = "SPARK_MASTER_WEBUI_PORT"
            value = var.spark_master_webui_port
          },
        ], var.env)
      }
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
