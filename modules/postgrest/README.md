
# Module `postgrest`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `PGRST_DB_ANON_ROLE` (default `"anon"`)
* `PGRST_DB_SCHEMA` (default `"public"`)
* `PGRST_DB_URI` (required): postgres://user:password@host:port/db?sslmode=disable'
* `PGRST_JWT_SECRET` (required): `openssl rand -base64 32`
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"postgrest/postgrest:latest"`)
* `name` (default `"postgrest"`)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":3000}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"128Mi"}}`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

