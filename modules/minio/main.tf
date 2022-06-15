locals {
  input_env = merge(
    var.env_file != null ? { for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1] } : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  servers = [
    for i in range(0, var.replicas) :
    "http://${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local/data/${var.name}-${i}"
  ]

  parameters = {
    name        = var.name
    namespace   = var.namespace
    replicas    = var.replicas
    ports       = var.ports
    annotations = var.annotations

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "minio"
        image = var.image

        args = coalescelist(var.args, concat(["server", "--console-address", ":${var.ports[1].port}"], local.servers))

        env = concat([
          var.minio_access_key != null ? {
            name  = "MINIO_ROOT_USER"
            value = var.minio_access_key
          } : {},
          var.minio_secret_key != null ? {
            name  = "MINIO_ROOT_PASSWORD"
            value = var.minio_secret_key
          }: {},
        ], var.env, local.computed_env)

        env_from = var.env_from

        liveness_probe = {
          failure_threshold = 3
          http_get = {
            path   = "/minio/health/live"
            port   = var.ports[0].port
            scheme = "HTTP"
          }
          initial_delay_seconds = 60
          period_seconds        = 30
          success_threshold     = 1
          timeout_seconds       = 20
        }

        resources = var.resources

        volume_mounts = var.storage != null ? [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
          }
        ] : []
      },
      {
        name  = "mc"
        image = "minio/mc"
        command = [
          "bash",
          "-c",
          <<-EOF
          if [ ! -z "$$MINIO_ROOT_USER" ]; then
            until mc alias set local http://localhost:9000 $$MINIO_ROOT_USER $$MINIO_ROOT_PASSWORD; do
              sleep 10
            done
          fi

          exec sleep infinity
          EOF
        ]

        env = concat([
          var.minio_access_key != null ? {
            name  = "MINIO_ROOT_USER"
            value = var.minio_access_key
          } : {},
          var.minio_secret_key != null ? {
            name  = "MINIO_ROOT_PASSWORD"
            value = var.minio_secret_key
          }: {},
        ], var.env, local.computed_env)

        env_from = var.env_from
      },
    ]

    node_selector        = var.node_selector
    service_account_name = var.service_account_name

    volume_claim_templates = var.storage != null ? [
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
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
