
# Module `synapse`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `client_id` (required)
* `client_secret` (required)
* `issuer` (required)
* `name` (default `"synapse"`)
* `namespace` (default `"synapse-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `synapse` from [../../modules/synapse](../../modules/synapse)

