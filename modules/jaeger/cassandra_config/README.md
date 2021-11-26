
# Module `jaeger/cassandra_config`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `name` (default `"jaeger-configuration"`)
* `namespace` (required)

## Output Values
* `name`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Data Resources
* `data.template_file.config` from `template`

