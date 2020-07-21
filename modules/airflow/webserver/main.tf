locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "webserver"
        image = var.image
        command = ["airflow", "webserver"]

        env = concat([
          {
            name = "AIRFLOW__CORE__SQL_ALCHEMY_CONN"
            value = var.AIRFLOW__CORE__SQL_ALCHEMY_CONN
          },
          {
            name  = "GUNICORN_CMD_ARGS"
            value = "--log-level WARNING"
          },
        ], var.env)

        volume_mounts = concat(
          var.pvc_dags != null ? [
          {
            name       = "dags"
            mount_path = "/opt/airflow/dags"
          },
          ] : [],
          var.pvc_logs != null ? [
            {
              name       = "logs"
              mount_path = "/opt/airflow/logs"
            },
          ] : [],
        )
      }
    ]

    init_containers = [
      {
        name  = "chown"
        image = var.image
        command = [
          "sh",
          "-cx",
          <<-EOF
          chown airflow /opt/airflow/dags
          EOF
        ]
        security_context = {
          run_asuser  = "0"
        }
        volume_mounts = concat(
          var.pvc_dags != null ? [
          {
            name       = "dags"
            mount_path = "/opt/airflow/dags"
          },
          ] : [],
        var.pvc_logs != null ? [
          {
            name       = "logs"
            mount_path = "/opt/airflow/logs"
          },
        ] : [],
        )
      },
    ]

    volumes = concat(
      var.pvc_dags != null ? [
      {
        name = "dags"
        persistent_volume_claim = {
          claim_name = var.pvc_dags
        }
      },
      ] : [],
      var.pvc_logs != null ? [
        {
          name = "logs"
          persistent_volume_claim = {
            claim_name = var.pvc_logs
          }
        },
      ] : [],
    )

  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
