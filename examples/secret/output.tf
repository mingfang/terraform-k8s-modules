output "secret_ref" {
  value = module.secret.secret_ref
}

output "secret_ref_prefix" {
  value = merge(module.secret.secret_ref, { prefix = "test_" })
}
