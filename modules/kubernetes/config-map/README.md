
# Module `kubernetes/config-map`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `annotations` (default `{}`)
* `from-dir` (default `null`)
* `from-file` (default `null`)
* `from-files` (default `[]`)
* `from-map` (default `{}`)
* `labels` (default `null`)
* `name` (required)
* `namespace` (required)

## Output Values
* `checksum`
* `config_map`
* `name`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

