
# Module `grafana/promtail`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `config_file` (default `""`)
* `env` (default `[]`)
* `image` (default `"grafana/promtail:2.2.1"`)
* `loki_url` (required)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `tenant_id` (default `""`)

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)
* `daemonset` from [../../../archetypes/daemonset](../../../archetypes/daemonset)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

