/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  domain_socket_path = "/tmp/${var.name}.sock"
  alluxio_java_opts = join(" ", [
    "-Dalluxio.master.hostname=${var.alluxio_master_hostname}",
    "-Dalluxio.master.port=${var.alluxio_master_port}",
    "-Dalluxio.worker.hostname=$${ALLUXIO_WORKER_HOSTNAME}",
    "-Dalluxio.locality.node=$${ALLUXIO_LOCALITY_NODE}",
    "-Dalluxio.worker.data.server.domain.socket.address=/opt/domain",
    "-Dalluxio.worker.data.server.domain.socket.as.uuid=true",
    var.extra_alluxio_java_opts
  ])

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    enable_service_links = false
    containers = [
      {
        name  = "alluxio"
        image = var.image

        args = [
          "worker"
        ]

        env = [
          {
            name = "ALLUXIO_WORKER_HOSTNAME"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "ALLUXIO_LOCALITY_NODE"
            value_from = {
              field_ref = {
                field_path = "spec.nodeName"
              }
            }
          },
          {
            name  = "ALLUXIO_JAVA_OPTS"
            value = local.alluxio_java_opts
          },
        ]

        volume_mounts = [
          {
            name       = "alluxio-ramdisk"
            mount_path = "/dev/shm"
          },
          {
            name       = "alluxio-domain"
            mount_path = "/opt/domain"
          },
        ]
      }
    ]
    volumes = [
      {
        name = "alluxio-ramdisk"
        empty_dir = {
          medium    = "Memory"
          sizeLimit = "1G"
        }
      },
      {
        name = "alluxio-domain"
        host_path = {
          path = local.domain_socket_path
          type = "DirectoryOrCreate"
        }
      },
    ]
  }
}


module "daemonset" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
