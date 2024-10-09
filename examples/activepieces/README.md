
# Module `activepieces`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"activepieces"`)
* `namespace` (default `"activepieces-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.activepieces` from `k8s`

## Child Modules
* `activepieces` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `redis` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

