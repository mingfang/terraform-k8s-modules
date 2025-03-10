
# Module `baserow/web-frontend`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `INITIAL_TABLE_DATA_LIMIT` (default `null`)
* `PRIVATE_BACKEND_URL` (required)
* `PUBLIC_BACKEND_URL` (required)
* `PUBLIC_WEB_FRONTEND_URL` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/baserow-web-frontend:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":3000}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

