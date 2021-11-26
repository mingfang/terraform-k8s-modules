
# Module `prefect/apollo`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `HASURA_API_URL` (required): http://hasura:3000/v1alpha1/graphql
* `PREFECT_API_HEALTH_URL` (required): http://graphql:4201/health
* `PREFECT_API_URL` (required): http://graphql:4201/graphql/
* `PREFECT_SERVER__TELEMETRY__ENABLED` (default `true`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"prefecthq/apollo:0.12.6"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":4200}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

