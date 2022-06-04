
# Module `postgres`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `POSTGRES_DB` (default `null`)
* `POSTGRES_PASSWORD` (default `null`)
* `POSTGRES_USER` (default `null`)
* `annotations` (default `{}`)
* `args` (default `null`)
* `command` (default `null`)
* `configmap` (default `null`): keys must be *.sql files used for db initialization
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_map` (default `{}`)
* `image` (default `"postgres:12.1"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":5432}]`)
* `replicas` (default `1`): hardcoded to 1
* `resources` (default `{"requests":{"cpu":"100m","memory":"128Mi"}}`)
* `service_account_name` (default `null`)
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

