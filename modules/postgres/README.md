
# Module `postgres`

## Input Variables
* `POSTGRES_DB` (required)
* `POSTGRES_PASSWORD` (required)
* `POSTGRES_USER` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"postgres:12.1"`)
* `name` (default `"postgres"`)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":5432}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"128Mi"}}`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

