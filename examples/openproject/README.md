
# Module `openproject`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"openproject"`)
* `namespace` (default `"openproject-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.assets` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `memcached` from [../../modules/memcached](../../modules/memcached)
* `openproject` from [../../modules/openproject](../../modules/openproject)
* `postgres` from [../../modules/postgres](../../modules/postgres)

