
# Module `postgres`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"postgres"`)
* `namespace` (default `"postgres-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `postgres` from [../../modules/postgres](../../modules/postgres)

