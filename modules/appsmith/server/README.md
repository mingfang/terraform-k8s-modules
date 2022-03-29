
# Module `appsmith/server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `APPSMITH_ENCRYPTION_PASSWORD` (required)
* `APPSMITH_ENCRYPTION_SALT` (required)
* `APPSMITH_MONGODB_URI` (required)
* `APPSMITH_REDIS_URL` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"appsmith/appsmith-server:v1.6.16"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

