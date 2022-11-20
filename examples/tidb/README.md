
# Module `tidb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"tidb"`)
* `namespace` (default `"tidb-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `pd` from [../../modules/tidb/pd](../../modules/tidb/pd)
* `tidb` from [../../modules/tidb/tidb](../../modules/tidb/tidb)
* `tikv` from [../../modules/tidb/tikv](../../modules/tidb/tikv)

