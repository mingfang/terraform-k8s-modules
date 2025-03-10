
# Module `redash/server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `REDASH_DATABASE_URL` (required)
* `REDASH_REDIS_URL` (required)
* `REDASH_WEB_WORKERS` (default `4`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"redash/redash:10.0.0-beta.b49597"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":5000}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

