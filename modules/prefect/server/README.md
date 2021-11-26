
# Module `prefect/server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `PREFECT_SERVER__DATABASE__CONNECTION_URL` (required)
* `PREFECT_SERVER__HASURA__ADMIN_SECRET` (default `""`)
* `PREFECT_SERVER__HASURA__HOST` (required)
* `PREFECT_SERVER__HASURA__PORT` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"prefecthq/server:0.12.6"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":4201}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

