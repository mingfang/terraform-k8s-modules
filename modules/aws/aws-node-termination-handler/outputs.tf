output "name" {
  value = var.name
}

output "deployment" {
  value = module.daemonset.daemonset
}
