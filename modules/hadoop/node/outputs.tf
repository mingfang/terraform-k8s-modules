output "name" {
  value = k8s_core_v1_service.this.metadata[0].name
}

output "port" {
  value = k8s_core_v1_service.this.spec[0].ports[0].port
}

output "cluster_ip" {
  value = k8s_core_v1_service.this.spec[0].cluster_ip
}

output "deployment_uid" {
  value = k8s_apps_v1_deployment.this.metadata[0].uid
}

