resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca_cert" {
  subject {
    common_name = "${var.name}.${var.namespace}.ca"
  }

  is_ca_certificate     = true
  private_key_pem       = tls_private_key.ca_key.private_key_pem
  validity_period_hours = 87600

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

resource "tls_private_key" "cert_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "cert_request" {
  dns_names = ["${var.name}.${var.namespace}.svc"]

  subject {
    common_name = "${var.name}.${var.namespace}.svc"
  }
  private_key_pem = tls_private_key.cert_key.private_key_pem
}

resource "tls_locally_signed_cert" "cert" {
  cert_request_pem   = tls_cert_request.cert_request.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 87600
  allowed_uses = [
    "client_auth",
    "server_auth",
    "key_encipherment",
    "digital_signature",
  ]
}

module "cert_secret" {
  source    = "../../modules/kubernetes/secret"
  name      = "cert"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  from-map = {
    "ca.crt"  = base64encode(tls_self_signed_cert.ca_cert.cert_pem)
    "tls.crt" = base64encode(tls_locally_signed_cert.cert.cert_pem)
    "tls.key" = base64encode(tls_private_key.cert_key.private_key_pem)
  }
}
