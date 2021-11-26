
# Module `spark/worker`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/spark"`)
* `master_url` (required)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `spark_worker_webui_port` (default `8081`)

## Output Values
* `daemonset`
* `name`

## Child Modules
* `daemonset` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/daemonset`

