
# Module `keycloak`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `DB_ADDR` (default `""`)
* `DB_DATABASE` (default `""`)
* `DB_PASSWORD` (default `""`)
* `DB_PORT` (default `""`)
* `DB_SCHEMA` (default `""`)
* `DB_USER` (default `""`)
* `DB_VENDOR` (default `"h2"`)
* `KEYCLOAK_PASSWORD` (required)
* `KEYCLOAK_USER` (required)
* `PROXY_ADDRESS_FORWARDING` (default `true`)
* `annotations` (default `{}`)
* `args` (default `[]`)
* `command` (default `[]`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"quay.io/keycloak/keycloak:16.1.1"`)
* `name` (default `"keycloak"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `post_start_command` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

