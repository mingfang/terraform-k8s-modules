output "name" {
  value = module.statefulset-service.name
}

output "port" {
  value = module.statefulset-service.service.spec.0.ports.0.port
}

output "service" {
  value = module.statefulset-service.service
}

output "statefulset" {
  value = module.statefulset-service.statefulset
}
