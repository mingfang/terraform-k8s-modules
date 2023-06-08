
# Module `spark/master`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/spark"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `spark_master_port` (default `7077`)
* `spark_master_webui_port` (default `8080`)

## Output Values
* `deployment`
* `master_url`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

