
# Module `supabase/gotrue`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `API_EXTERNAL_URL` (required)
* `DATABASE_URL` (required): postgres://user:password@host:port/db?sslmode=disable'
* `DB_NAMESPACE` (default `"auth"`)
* `GOTRUE_API_HOST` (default `"0.0.0.0"`)
* `GOTRUE_DB_DRIVER` (default `"postgres"`)
* `GOTRUE_DISABLE_SIGNUP` (default `"false"`)
* `GOTRUE_JWT_DEFAULT_GROUP_NAME` (default `"authenticated"`)
* `GOTRUE_JWT_EXP` (default `3600`)
* `GOTRUE_JWT_SECRET` (required)
* `GOTRUE_LOG_LEVEL` (default `"INFO"`)
* `GOTRUE_MAILER_AUTOCONFIRM` (default `"true"`)
* `GOTRUE_OPERATOR_TOKEN` (required)
* `GOTRUE_SITE_URL` (required)
* `GOTRUE_SMTP_HOST` (required)
* `GOTRUE_SMTP_PASS` (required)
* `GOTRUE_SMTP_PORT` (required)
* `GOTRUE_SMTP_USER` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"supabase/gotrue:latest"`)
* `name` (default `"gotrue"`)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":9999}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"128Mi"}}`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

