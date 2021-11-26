
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
* `env` (default `[]`)
* `image` (default `"jboss/keycloak:13.0.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

