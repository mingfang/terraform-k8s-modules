
# Module `redis`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"redis"`)
* `namespace` (default `"redis-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `redis` from [../../modules/redis](../../modules/redis)

