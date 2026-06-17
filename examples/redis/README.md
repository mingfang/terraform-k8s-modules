
# Module `redis`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"redis"`)
* `namespace` (default `"redis-example"`)

## Child Modules
* `namespace` from [../namespace](../namespace)
* `redis` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

