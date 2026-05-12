output "name" {
  description = "Name of the PostgreSQL cluster."
  value       = k8s_postgresql_cnpg_io_v1_cluster.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the PostgreSQL cluster."
  value       = k8s_postgresql_cnpg_io_v1_cluster.this.metadata[0].namespace
}

output "primary_service_name" {
  description = "Name of the primary service."
  value       = "${var.name}-rw"
}

output "read_service_name" {
  description = "Name of the read service."
  value       = "${var.name}-ro"
}

output "pooler_service_name" {
  description = "PgBouncer pooler service name. Only set when pooler.name is provided."
  value       = local.pooler_enabled ? "${var.name}-pooler" : null
}

output "password_secret_name" {
  description = "Name of the password secret."
  value       = local.password_secret_name
}
