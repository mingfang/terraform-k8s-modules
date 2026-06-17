
# Module `postgres`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"postgres"`)
* `namespace` (default `"postgres-example"`)

## Child Modules
* `namespace` from [../namespace](../namespace)
* `postgres` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)

