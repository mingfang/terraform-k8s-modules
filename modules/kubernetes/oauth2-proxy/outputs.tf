output "service" {
  value = k8s_core_v1_service.oauth2-proxy
}

output "deployment" {
  value = k8s_apps_v1_deployment.oauth2-proxy
}
