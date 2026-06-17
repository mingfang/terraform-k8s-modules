output "name" {
  description = "Omnigraph service name"
  value       = module.omnigraph.name
}

output "port" {
  description = "Omnigraph service port"
  value       = module.omnigraph.ports[0].port
}

output "namespace" {
  description = "Kubernetes namespace"
  value       = module.namespace.name
}
