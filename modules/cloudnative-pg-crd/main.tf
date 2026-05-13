locals {
  # Read the embedded CNPG operator YAML manifest
  cnpg_manifest = file("${path.module}/cnpg-${var.operator_version}.yaml")
}

resource "null_resource" "operator" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f - <<'YAML'
      ${local.cnpg_manifest}
      YAML
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kubectl delete -f - <<'YAML'
      ${local.cnpg_manifest}
      YAML
    EOT
  }

  triggers = {
    operator_version = var.operator_version
    manifest_sha     = sha256(local.cnpg_manifest)
  }
}
