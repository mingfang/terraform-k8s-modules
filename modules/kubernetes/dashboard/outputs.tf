output "service" {
  value = k8s_core_v1_service.kubernetes-dashboard
}

output "deployment" {
  value = k8s_apps_v1_deployment.kubernetes-dashboard
}