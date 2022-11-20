
# Module `surrealdb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"surrealdb"`)
* `namespace` (default `"surrealdb-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `pd` from [../../modules/tidb/pd](../../modules/tidb/pd)
* `surrealdb` from [../../modules/surrealdb](../../modules/surrealdb)
* `tikv` from [../../modules/tidb/tikv](../../modules/tidb/tikv)

