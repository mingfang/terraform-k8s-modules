
# Module `sentry/config`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (required)
* `namespace` (required)

## Output Values
* `config_map`

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)

