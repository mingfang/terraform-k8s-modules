
# Module `appwrite/appwrite`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `_APP_DB_HOST` (required)
* `_APP_DB_PASS` (required)
* `_APP_DB_PORT` (required)
* `_APP_DB_SCHEMA` (required)
* `_APP_DB_USER` (required)
* `_APP_ENV` (default `"production"`): development or production(default)
* `_APP_INFLUXDB_HOST` (default `null`)
* `_APP_INFLUXDB_PORT` (default `8086`)
* `_APP_REDIS_HOST` (required)
* `_APP_REDIS_PORT` (default `"6379"`)
* `_APP_STORAGE_ANTIVIRUS` (default `"disabled"`)
* `_APP_USAGE_STATS` (default `"disabled"`): enabled or disabled
* `annotations` (default `{}`)
* `command` (default `null`)
* `env` (default `[]`)
* `image` (default `"appwrite/appwrite:0.13.4"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `pvcs` (default `[]`): array of PVCs, e.g. functions, builds, etc
* `replicas` (default `1`)
* `sidecars` (default `[]`): sidecar containers, e.g. docker in docker

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

