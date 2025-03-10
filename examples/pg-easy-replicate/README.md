
# Module `pg-easy-replicate`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"pg-easy-replicate"`)
* `namespace` (default `"pg-easy-replicate-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `pg-easy-replicate` from [../../modules/pg-easy-replicate](../../modules/pg-easy-replicate)
* `postgres15` from [../../modules/postgres](../../modules/postgres)
* `postgres16` from [../../modules/postgres](../../modules/postgres)

