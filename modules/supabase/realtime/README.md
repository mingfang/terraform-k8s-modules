
# Module `supabase/realtime`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `DB_HOST` (required)
* `DB_NAME` (required)
* `DB_PASSWORD` (required)
* `DB_PORT` (required)
* `DB_USER` (required)
* `HOSTNAME` (default `"0.0.0.0"`)
* `JWT_SECRET` (required)
* `SECURE_CHANNELS` (default `"false"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"supabase/realtime:latest"`)
* `name` (default `"realtime"`)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":4000}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"128Mi"}}`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

