
# Module `openmaptiles`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"openmaptiles"`)
* `namespace` (default `"openmaptiles-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `import-data-job` from [../../modules/openmaptiles/import-data-job](../../modules/openmaptiles/import-data-job)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `postserve` from [../../modules/openmaptiles/postserve](../../modules/openmaptiles/postserve)

