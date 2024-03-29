
# Module `appwrite/worker-usage`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `_APP_DB_HOST` (required)
* `_APP_DB_PASS` (required)
* `_APP_DB_PORT` (required)
* `_APP_DB_SCHEMA` (required)
* `_APP_DB_USER` (required)
* `_APP_ENV` (default `"production"`): development or production(default)
* `_APP_REDIS_HOST` (required)
* `_APP_REDIS_PORT` (default `"6379"`)
* `_APP_STATSD_HOST` (required)
* `_APP_STATSD_PORT` (default `8125`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"appwrite/appwrite:0.13.4"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

