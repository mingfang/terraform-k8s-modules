
# Module `nifi/minifi`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `c2_hostname` (required)
* `image` (default `"apache/nifi-minifi:0.5.0"`)
* `name` (required)
* `namespace` (default `null`)
* `node_selector` (default `null`)
* `overrides` (default `{}`)

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Child Modules
* `daemonset` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/daemonset`

