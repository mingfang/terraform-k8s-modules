locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas

    annotations = var.annotations

    enable_service_links = false

    containers = [
      {
        name  = "recommender"
        image = var.image
        env   = concat([], var.env)
      }
    ]

    service_account_name = module.rbac.name

    security_context = {
      run_asnon_root = true
      run_asuser     = 65534
    }

    tolerations = [
      {
        effect = "NoSchedule"
        key    = "CriticalAddonsOnly"
      },
      {
        effect = "NoSchedule"
        key    = "node.kubernetes.io/master"
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
