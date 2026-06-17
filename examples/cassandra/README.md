
# Module `cassandra`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"cassandra"`)
* `namespace` (default `"cassandra-example"`)

## Child Modules
* `cassandra` from [../../modules/generic-statefulset-service](../../modules/generic-statefulset-service)
* `namespace` from [../namespace](../namespace)

