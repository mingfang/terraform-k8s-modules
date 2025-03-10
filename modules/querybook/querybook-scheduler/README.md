
# Module `querybook/querybook-scheduler`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `DATABASE_CONN` (required)
* `ELASTICSEARCH_HOST` (required)
* `FLASK_SECRET_KEY` (required)
* `REDIS_URL` (required)
* `annotations` (default `{}`)
* `args` (default `["./querybook/scripts/runservice","prod_scheduler","--pidfile=/opt/celerybeat.pid"]`)
* `command` (default `null`)
* `configmap` (default `null`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_map` (default `{}`)
* `image` (default `"querybook/querybook:latest"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `pvc` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"200Mi"}}`)
* `service_account_name` (default `null`)

## Output Values
* `deployment`
* `name`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

