
# Module `risingwave`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"risingwave"`)
* `namespace` (default `"risingwave-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.this` from `k8s`

## Child Modules
* `compactor-node` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `compute-node` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `frontend` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `meta-node` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `minio` from [../../modules/minio](../../modules/minio)
* `postgres` from [../../modules/postgres](../../modules/postgres)

