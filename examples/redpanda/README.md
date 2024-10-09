
# Module `redpanda`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"redpanda"`)
* `namespace` (default `"redpanda-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.kowl` from `k8s`
* `k8s_networking_k8s_io_v1_ingress.redpanda` from `k8s`

## Child Modules
* `kowl` from [../../modules/kowl](../../modules/kowl)
* `kowl_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `redpanda` from [../../modules/redpanda](../../modules/redpanda)

