
# Module `tooljet`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"tooljet"`)
* `namespace` (default `"tooljet-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `namespace` from [../namespace](../namespace)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `postgrest` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `tooljet` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

