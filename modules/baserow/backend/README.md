
# Module `baserow/backend`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `DATABASE_HOST` (required)
* `DATABASE_NAME` (required)
* `DATABASE_PASSWORD` (required)
* `DATABASE_PORT` (default `null`)
* `DATABASE_USER` (required)
* `MEDIA_URL` (required)
* `MIGRATE_ON_STARTUP` (default `"true"`)
* `PUBLIC_BACKEND_URL` (required)
* `PUBLIC_WEB_FRONTEND_URL` (required)
* `REDIS_HOST` (required)
* `REDIS_PASSWORD` (default `""`)
* `REDIS_PORT` (default `null`)
* `REDIS_PROTOCOL` (default `"redis"`)
* `REDIS_USER` (default `""`)
* `SYNC_TEMPLATES_ON_STARTUP` (default `"true"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/baserow-backend:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8000}]`)
* `pvc_media` (default `null`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

