
# Module `appwrite/telegraf`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `_APP_INFLUXDB_HOST` (required)
* `_APP_INFLUXDB_PORT` (default `8086`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"appwrite/telegraf:1.2.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8125}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

