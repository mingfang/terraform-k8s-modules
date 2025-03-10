output "name" {
  value = module.daemonset.name
}

output "daemonset" {
  value = module.daemonset.daemonset
}

output "domain_socket_path" {
  value = local.domain_socket_path
}