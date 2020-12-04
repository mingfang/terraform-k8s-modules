locals {
  parameters = {
    name                        = var.name
    namespace                   = var.namespace
    annotations                 = var.annotations
    replicas                    = var.replicas
    ports                       = var.ports

    enable_service_links        = false
    pod_management_policy       = "Parallel"
    publish_not_ready_addresses = true

    containers = [
      {
        name  = "cluster-agent"
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
          "--probe.kubernetes.role=cluster",
          "--probe.http.listen=:4041",
          "--probe.publish.interval=4500ms",
          "--probe.spy.interval=2s",
          "--weave=false",
          var.weave_scope_app_url,
        ]

        resources = var.resources
      },
    ]

    service_account_name = module.rbac.name
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}