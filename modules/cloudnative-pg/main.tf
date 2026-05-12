resource "null_resource" "operator" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -fsSL "https://github.com/cloudnative-pg/cloudnative-pg/releases/download/v${var.operator_version}/cnpg-${var.operator_version}.yaml" | \
      kubectl apply -f -
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      curl -fsSL "https://github.com/cloudnative-pg/cloudnative-pg/releases/download/v${self.triggers.operator_version}/cnpg-${self.triggers.operator_version}.yaml" | \
      kubectl delete --ignore-not-found=true -f -
    EOT
  }

  triggers = {
    operator_version = var.operator_version
  }
}
