
# Module `citus`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"citus"`)
* `namespace` (default `"citus-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `coordinator` from [../../modules/citus/coordinator](../../modules/citus/coordinator)
* `secret` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `worker` from [../../modules/citus/worker](../../modules/citus/worker)

