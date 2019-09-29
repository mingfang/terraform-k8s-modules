output "service" {
  value = k8s_core_v1_service.ingress-nginx
}

output "deployment" {
  value = k8s_apps_v1_deployment.nginx-ingress-controller
}

output "ingress_class" {
  value = var.ingress_class
}