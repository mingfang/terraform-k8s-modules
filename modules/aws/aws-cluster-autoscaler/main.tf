locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    enable_service_links = false

    containers = [
      {
        name  = "autoscaler"
        image = var.image

        command = [
          "./cluster-autoscaler",
          "--v=4",
          "--stderrthreshold=info",
          "--cloud-provider=aws",
          "--skip-nodes-with-local-storage=false",
          "--expander=least-waste",
          "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/$(CLUSTER_NAME)",
          "--namespace=$(NAMESPACE)",
          "--cordon-node-before-terminating=${var.cordon-node-before-terminating}",
          "--ignore-daemonsets-utilization=${var.ignore-daemonsets-utilization}",
          "--scale-down-unneeded-time=${var.scale-down-unneeded-time}",
        ]

        env = concat([
          {
            name  = "CLUSTER_NAME"
            value = var.CLUSTER_NAME
          },
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

    security_context = {
      run_asnon_root = true
      run_asuser     = 65534
      fsgroup        = 65534
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
