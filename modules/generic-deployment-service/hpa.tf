resource "k8s_autoscaling_v1_horizontal_pod_autoscaler" "this" {
  count = var.max_replicas == var.min_replicas ? 0 : 1

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = module.deployment-service.name
    }
    target_cpu_utilization_percentage = var.target_cpu_utilization_percentage
  }
}