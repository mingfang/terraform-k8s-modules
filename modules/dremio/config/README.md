
# Module `dremio/config`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (required)
* `namespace` (required)

## Output Values
* `config_map`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

