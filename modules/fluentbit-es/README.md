
# Module `fluentbit-es`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `null`)
* `env` (default `[]`)
* `fluent_elasticsearch_host` (required)
* `fluent_elasticsearch_port` (required)
* `image` (default `"fluent/fluent-bit:0.14.8"`)
* `name` (required)
* `namespace` (default `null`)
* `node_selector` (default `null`)
* `overrides` (default `{}`)

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Child Modules
* `daemonset` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/daemonset`
* `rbac` from `git::https://github.com/mingfang/terraform-k8s-modules.git//modules/kubernetes/rbac`

