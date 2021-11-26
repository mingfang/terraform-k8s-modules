
# Module `appwrite/appwrite`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `_APP_DB_HOST` (required)
* `_APP_DB_PASS` (required)
* `_APP_DB_PORT` (default `"6379"`)
* `_APP_DB_SCHEMA` (required)
* `_APP_DB_USER` (required)
* `_APP_ENV` (default `"production"`): development or production(default)
* `_APP_INFLUXDB_HOST` (required)
* `_APP_INFLUXDB_PORT` (default `8086`)
* `_APP_REDIS_HOST` (required)
* `_APP_REDIS_PORT` (default `"6379"`)
* `_APP_STORAGE_ANTIVIRUS` (default `"disabled"`)
* `_APP_USAGE_STATS` (default `"disabled"`): enabled or disabled
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"appwrite/appwrite:0.10.4"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `pvc_functions` (default `""`)
* `pvc_uploads` (default `""`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
