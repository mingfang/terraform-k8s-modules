
# Module `typedb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"typedb"`)
* `namespace` (default `"typedb-example"`)

## Child Modules
* `namespace` from [../namespace](../namespace)
* `typedb` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)

