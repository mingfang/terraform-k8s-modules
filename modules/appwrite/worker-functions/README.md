
# Module `appwrite/worker-functions`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `_APP_DB_HOST` (required)
* `_APP_DB_PASS` (required)
* `_APP_DB_PORT` (default `"6379"`)
* `_APP_DB_SCHEMA` (required)
* `_APP_DB_USER` (required)
* `_APP_ENV` (default `"production"`): development or production(default)
* `_APP_FUNCTIONS_CONTAINERS` (default `10`)
* `_APP_FUNCTIONS_CPUS` (default `1`)
* `_APP_FUNCTIONS_MEMORY` (default `256`)
* `_APP_FUNCTIONS_MEMORY_SWAP` (default `256`)
* `_APP_FUNCTIONS_TIMEOUT` (default `900`)
* `_APP_REDIS_HOST` (required)
* `_APP_REDIS_PORT` (default `"6379"`)
* `_APP_USAGE_STATS` (default `"disabled"`): enabled or disabled
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"appwrite/appwrite:0.13.4"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `pvc_functions` (default `""`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

