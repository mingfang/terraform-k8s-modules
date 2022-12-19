
# Module `pgadmin`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `PGADMIN_DEFAULT_EMAIL` (required)
* `PGADMIN_DEFAULT_PASSWORD` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"dpage/pgadmin4:6.17"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `pvc_name` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

