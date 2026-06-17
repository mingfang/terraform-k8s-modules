
# Module `temporal`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"temporal"`)
* `namespace` (default `"temporal-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.temporal` from `k8s`

## Child Modules
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `temporal` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `temporal-ui` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

