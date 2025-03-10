locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations

    enable_service_links        = false

    containers = [
      {
        name  = "agent"
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

        command = ["/home/weave/scope"]
        args = [
          "--mode=probe",
          "--probe-only",
          "--probe.kubernetes.role=host",
          "--probe.publish.interval=4500ms",
          "--probe.spy.interval=2s",
          "--probe.docker.bridge=kbr0",
          "--probe.docker=true",
          "--weave=false",
          var.weave_scope_app_url,
        ]

        resources = var.resources

        security_context = {
          privileged = true
        }

        volume_mounts = [
          {
            name       = "scope-plugins"
            mount_path = "/var/run/scope/plugins"
          },
          {
            name       = "sys-kernel-debug"
            mount_path = "/sys/kernel/debug"
          },
          {
            name       = "docker-socket"
            mount_path = "/var/run/docker.sock"
          },
        ]
      },
    ]

    dns_policy = "ClusterFirstWithHostNet"
    host_network = true
    host_pid = true

    volumes = [
      {
        name = "scope-plugins"
        hostPath = {
          path = "/var/run/scope/plugins"
        }
      },
      {
        name = "sys-kernel-debug"
        hostPath = {
          path = "/sys/kernel/debug"
        }
      },
      {
        name = "docker-socket"
        hostPath = {
          path = "/var/run/docker.sock"
        }
      },
    ]
  }
}

module "daemonset" {
  source     = "../../../archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}