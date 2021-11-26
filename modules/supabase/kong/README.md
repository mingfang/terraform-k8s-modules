
# Module `supabase/kong`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `KONG_DECLARATIVE_CONFIG` (default `"/var/lib/kong/kong.yml"`)
* `KONG_PLUGINS` (default `"request-transformer,cors,key-auth,http-log"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/supabase-kong"`)
* `name` (default `"kong"`)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8000},{"name":"https","port":8443}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"128Mi"}}`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

