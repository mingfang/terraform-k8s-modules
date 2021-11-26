
# Module `appsmith`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"appsmith"`)
* `namespace` (default `"appsmith-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `editor` from [../../modules/appsmith/editor](../../modules/appsmith/editor)
* `mongodb` from [../../modules/mongodb](../../modules/mongodb)
* `redis` from [../../modules/redis](../../modules/redis)
* `server` from [../../modules/appsmith/server](../../modules/appsmith/server)

