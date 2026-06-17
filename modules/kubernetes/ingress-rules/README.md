
# Module `kubernetes/ingress-rules`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `ingress_class` (default `null`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `rules` (required)
* `tls` (default `null`)

## Output Values
* `rules`

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

