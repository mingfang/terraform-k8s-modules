locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    enable_service_links = false

    containers = [
      {
        name  = "cloud-provider"
        image = var.image

        args = [
          "--v=4",
          "--cloud-provider=aws",
          "--leader-elect=true",
          "--use-service-account-credentials=true",
          "--configure-cloud-routes=false",
          "--controllers=cloud-node,cloud-node-lifecycle"
        ]

        env = concat([
          {
            name = "NAMESPACE"
            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
        ], var.env)

        resources = var.resources
      }
    ]

    node_selector = merge(
      {
        "kubernetes.io/arch" = "amd64"
        "kubernetes.io/os"   = "linux"
      },
      var.node_selector
    )

    priority_class_name  = "system-cluster-critical"
    service_account_name = module.rbac.name

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

module "daemonset" {
  source     = "../../../archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
