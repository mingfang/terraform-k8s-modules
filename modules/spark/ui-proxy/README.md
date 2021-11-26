
# Module `spark/ui-proxy`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `image` (default `"ursuad/spark-ui-proxy"`)
* `master_host` (required)
* `master_port` (required)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

