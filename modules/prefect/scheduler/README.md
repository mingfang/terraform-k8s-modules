
# Module `prefect/scheduler`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `PREFECT_SERVER__HASURA__ADMIN_SECRET` (default `""`)
* `PREFECT_SERVER__HASURA__HOST` (required)
* `PREFECT_SERVER__HASURA__PORT` (required)
* `PREFECT_SERVER__SERVICES__SCHEDULER__SCHEDULER_LOOP_SECONDS` (default `10`): run scheduler every X seconds
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"prefecthq/server:0.12.6"`)
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

