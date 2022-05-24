
# Module `cortex/agent`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `config_file` (default `""`)
* `env` (default `[]`)
* `image` (default `"grafana/agent:v0.4.0"`)
* `log_level` (default `"info"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `remote_write_url` (required)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)
* `daemonset` from [../../../archetypes/daemonset](../../../archetypes/daemonset)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

