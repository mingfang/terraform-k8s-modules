locals {
  initial-cluster = join(",",
    [
      for i in range(0, var.replicas) :
      "${var.name}-${i}=http://${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:${var.ports[1].port}"
    ]
  )

  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    replicas                    = var.replicas
    ports                       = var.ports
    annotations                 = var.annotations
    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "etcd"
        image = var.image

        command = [
          "etcd",
          "--name=$(POD_NAME)",
          "--initial-advertise-peer-urls=http://$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:${var.ports[1].port}",
          "--listen-peer-urls=http://0.0.0.0:${var.ports[1].port}",
          "--advertise-client-urls=http://$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:${var.ports[0].port}",
          "--listen-client-urls=http://0.0.0.0:${var.ports[0].port}",
          "--initial-cluster=${local.initial-cluster}",
          "--initial-cluster-state=new",
          "--initial-cluster-token=${var.namespace}",
          "--data-dir=/data",
        ]

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
            name  = "ETCD_AUTO_COMPACTION_MODE"
            value = var.ETCD_AUTO_COMPACTION_MODE
          },
          {
            name  = "ETCD_AUTO_COMPACTION_RETENTION"
            value = var.ETCD_AUTO_COMPACTION_RETENTION
          },
          {
            name  = "ETCD_QUOTA_BACKEND_BYTES"
            value = var.ETCD_QUOTA_BACKEND_BYTES
          },
        ], var.env)

        resources = var.resources

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
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
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}