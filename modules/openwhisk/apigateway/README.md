
# Module `openwhisk/apigateway`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `REDIS_HOST` (required)
* `REDIS_PORT` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"openwhisk/apigateway:1.0.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"api","port":9000},{"name":"mgmt","port":8080}]`)
* `replicas` (default `1`)
* `whisk_config_name` (required)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

