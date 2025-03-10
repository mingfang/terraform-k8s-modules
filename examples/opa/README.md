
# Module `opa`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **tls:** (any version)

## Input Variables
* `name` (default `"opa"`)
* `namespace` (default `"opa-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `tls_cert_request.cert_request` from `tls`
* `tls_locally_signed_cert.cert` from `tls`
* `tls_private_key.ca_key` from `tls`
* `tls_private_key.cert_key` from `tls`
* `tls_self_signed_cert.ca_cert` from `tls`

## Child Modules
* `cert_secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `nginx` from [../../modules/nginx](../../modules/nginx)
* `opa` from [../../modules/opa](../../modules/opa)
* `podpreset` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `policies` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)

