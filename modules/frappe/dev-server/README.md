
# Module `frappe/dev-server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ADMIN_PASSWORD` (default `"frappe"`)
* `AUTO_MIGRATE` (default `"1"`)
* `DB_PORT` (default `null`): database port
* `DB_ROOT_USER` (default `"root"`)
* `GET_APPS` (default `"frappe"`): space seperated list of apps to get initially
* `MARIADB_HOST` (default `null`)
* `MYSQL_ROOT_PASSWORD` (default `null`)
* `POSTGRES_HOST` (default `null`)
* `POSTGRES_PASSWORD` (default `null`)
* `REDIS_CACHE` (default `null`): redis-cache:6379
* `REDIS_QUEUE` (default `null`): redis-queue:6379
* `REDIS_SOCKETIO` (default `null`): redis-socketio:6379
* `SITE_NAME` (default `"default"`)
* `SOCKETIO_PORT` (default `443`): 443
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/frappe"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":8000},{"name":"socketio","port":443}]`)
* `pvc_bench` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"256Mi"}}`)

## Output Values
* `SITE_NAME`
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

