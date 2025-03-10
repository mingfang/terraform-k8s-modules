
# Module `cachet`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `DB_DATABASE` (required)
* `DB_HOST` (required)
* `DB_PASSWORD` (required)
* `DB_USERNAME` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"cachethq/docker:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8000}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

