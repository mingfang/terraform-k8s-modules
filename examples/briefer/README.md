
# Module `briefer`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"briefer"`)
* `namespace` (default `"briefer-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.briefer` from `k8s`

## Child Modules
* `briefer-api` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `briefer-jupyter` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `briefer-web` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `postgres` from [../../modules/postgres](../../modules/postgres)

