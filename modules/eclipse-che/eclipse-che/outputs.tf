output "name" {
  value = k8s_core_v1_service.che-host.metadata.0.name
}

output "service" {
  value = k8s_core_v1_service.che-host
}

output "deployment" {
  value = k8s_extensions_v1beta1_deployment.che
}
