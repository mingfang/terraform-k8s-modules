output "name" {
  value = k8s_core_v1_secret.this.metadata[0].name
}

output "secret" {
  value = k8s_core_v1_secret.this
}

output "checksum" {
  value = md5(join("", keys(local.data), values(local.data)))
}

output "secret_ref" {
  value = {
    prefix = null,
    secret_ref = {
      name = var.name
    }
  }
}