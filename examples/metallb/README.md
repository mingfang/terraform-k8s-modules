
# Module `metallb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `namespace` (default `"metallb"`)

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`
* `k8s_core_v1_namespace.this` from `k8s`

## Child Modules
* `metal-lb` from [../../modules/metallb](../../modules/metallb)

