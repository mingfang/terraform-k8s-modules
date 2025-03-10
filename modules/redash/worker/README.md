
# Module `redash/worker`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `QUEUES` (default `"scheduled_queries,schemas,default,periodic"`)
* `REDASH_DATABASE_URL` (required)
* `REDASH_REDIS_URL` (required)
* `WORKERS_COUNT` (default `1`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"redash/redash:10.0.0-beta.b49597"`)
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

