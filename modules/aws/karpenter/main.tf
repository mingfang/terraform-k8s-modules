locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    ports                = var.ports
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "karpenter"
        image = var.image
        env   = concat([
          {
            name  = "CLUSTER_NAME"
            value = var.CLUSTER_NAME
          },
          {
            name  = "CLUSTER_ENDPOINT"
            value = var.CLUSTER_ENDPOINT
          },
          {
            name       = "SYSTEM_NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },

        ], var.env)
      }
    ]

    priority_class_name  = "system-cluster-critical"
    service_account_name = module.rbac.name

    security_context = {
      fsgroup = 1000
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
