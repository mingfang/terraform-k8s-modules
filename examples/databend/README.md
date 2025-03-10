
# Module `databend`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"databend"`)
* `namespace` (default `"databend-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `meta-service` from [../../modules/databend/meta-service](../../modules/databend/meta-service)
* `query-service` from [../../modules/databend/query-service](../../modules/databend/query-service)

