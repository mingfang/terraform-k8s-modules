
# Module `budibase/budibase-apps`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `BUDIBASE_ENVIRONMENT` (default `"PRODUCTION"`)
* `COUCH_DB_URL` (required)
* `ENABLE_ANALYTICS` (default `"false"`)
* `INTERNAL_API_KEY` (required)
* `JWT_SECRET` (required)
* `LOG_LEVEL` (default `"info"`)
* `MINIO_ACCESS_KEY` (required)
* `MINIO_SECRET_KEY` (required)
* `MINIO_URL` (required)
* `REDIS_PASSWORD` (required)
* `REDIS_URL` (required)
* `SELF_HOSTED` (default `1`)
* `SENTRY_DSN` (default `null`)
* `WORKER_URL` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"budibase/apps:v1.0.98"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":4002}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"125m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

