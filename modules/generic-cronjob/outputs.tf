output "name" {
  value = var.name
}

output "cronjob" {
  value = module.cronjob.cronjob
}
