output "name" {
    value = var.is_create ? k8s_core_v1_namespace.this[0].metadata[0].name : var.name
}