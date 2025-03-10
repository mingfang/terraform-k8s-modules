
# Module `openmaptiles/import-data-job`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (required)
* `image` (default `"openmaptiles/import-data:6.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)

## Child Modules
* `job` from [../../../archetypes/job](../../../archetypes/job)

