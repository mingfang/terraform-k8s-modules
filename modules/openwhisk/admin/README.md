
# Module `openwhisk/admin`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `db_config_name` (required)
* `db_secret_name` (required)
* `env` (default `[]`)
* `image` (default `"openwhisk/ow-utils:71b7d56"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `whisk_config_name` (required)
* `whisk_secret_name` (required)

## Output Values
* `deployment`
* `name`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

