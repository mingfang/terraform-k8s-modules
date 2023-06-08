resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

module "policies" {
  source    = "../../modules/kubernetes/config-map"
  name      = "policies"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-dir = "${path.module}/policies"
}

module "opa" {
  source      = "../../modules/opa"
  name        = var.name
  namespace   = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    checksum = module.policies.checksum
  }

  secret_name         = module.cert_secret.name
  policies_config_map = module.policies.name
  default_decision    = "system.main"

  cert_pem = tls_self_signed_cert.ca_cert.cert_pem
}
