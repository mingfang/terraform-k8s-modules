resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca_cert" {
  subject {
    common_name  = "example.ca"
  }

  is_ca_certificate = true
  private_key_pem = tls_private_key.ca_key.private_key_pem
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
  subject {
    common_name  = "example.com"
  }
  private_key_pem = tls_private_key.cert_key.private_key_pem
}

resource "tls_locally_signed_cert" "cert" {
  cert_request_pem = tls_cert_request.cert_request.cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 87600
  allowed_uses = [
    "server_auth",
    "key_encipherment",
    "digital_signature",
  ]
}
/*
output "cert_request_pem" {
  value = tls_cert_request.cert_request.cert_request_pem
}
*/

/*
output "ca_private_key_pem" {
  value = tls_self_signed_cert.ca_cert.private_key_pem
}
*/

/*
output "ca_cert_pem" {
  value = tls_self_signed_cert.ca_cert.cert_pem
}
*/

