
# Module `openwhisk/controller`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `KAFKA_HOSTS` (required)
* `annotations` (default `{}`)
* `db_config_name` (required)
* `db_secret_name` (required)
* `env` (default `[]`)
* `image` (default `"openwhisk/controller:71b7d56"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"controller","port":8080}]`)
* `replicas` (default `1`)
* `whisk_config_name` (required)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

