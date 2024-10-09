
# Module `coder`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"coder"`)
* `namespace` (default `"coder-example"`)

## Managed Resources
* `k8s_core_v1_namespace.coder` from `k8s`
* `k8s_core_v1_persistent_volume_claim.data` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.coder` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.coder-wildcard` from `k8s`

## Child Modules
* `coder` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)
* `postgres` from [../../modules/postgres](../../modules/postgres)

