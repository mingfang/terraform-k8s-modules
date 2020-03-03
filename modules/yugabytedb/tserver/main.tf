/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations
    replicas                    = var.replicas
    ports                       = var.ports
    enable_service_links        = false
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "tserver"
        image = var.image

        env = concat([
          {
            name = "HOSTNAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "POD_IP"

            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
        ], var.env)

        command = [
          "sh",
          "-cx",
          <<-EOF
          /home/yugabyte/bin/yb-tserver \
            --tserver_master_addrs=${var.tserver_master_addrs} \
            --start_pgsql_proxy \
            --pgsql_proxy_bind_address $(HOSTNAME):5433 \
            --cql_proxy_bind_address $(HOSTNAME):9042 \
            --rpc_bind_addresses=$(HOSTNAME).${var.name}.${var.namespace}:9100 \
            --fs_data_dirs=/data/$(HOSTNAME) \
            --replication_factor=${var.replicas} \
            --undefok=num_cpus,enable_ysql \
            --metric_node_name=$(HOSTNAME) \
            --stderrthreshold=0 \
            --logtostderr
          EOF
        ]

        resources = {
          requests = {
            cpu    = "500m"
            memory = "1Gi"
          }
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          }
        ]
      },
      {
        name  = "yb-cleanup"
        image = "busybox:1.31"

        env = [
          {
            name  = "USER"
            value = "yugabyte"
          },
        ]

        command = [
          "sh",
          "-cx",
          <<-EOF
          mkdir /var/spool/cron;
          mkdir /var/spool/cron/crontabs;
          echo "0 0 * * * /home/yugabyte/scripts/log_cleanup.sh" | tee -a /var/spool/cron/crontabs/root;
          crond;
          while true; do
            sleep 86400;
          done
          EOF
        ]

        lifecycle = {
          post_start = {
            exec = {
              command = [
                "sh",
                "-cx",
                <<-EOF
                mkdir -p /mnt/disk0/cores;
                mkdir -p /mnt/disk0/yb-data/scripts;
                if [ -f /home/yugabyte/bin/log_cleanup.sh ]; then
                  cp /home/yugabyte/bin/log_cleanup.sh /mnt/disk0/yb-data/scripts;
                fi
                EOF
              ]
            }
          }
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          }
        ]
      },
    ]

    init_containers = [
      {
        name  = "init-sysctl"
        image = "busybox"

        command = [
          "sh",
          "-cx",
          <<-EOF
          sysctl -w vm.swappiness=0
          sysctl -w kernel.core_pattern="/home/yugabyte/cores/core_%e.%p"
          EOF
        ]

        security_context = {
          privileged = true
        }
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
  source     = "../../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}