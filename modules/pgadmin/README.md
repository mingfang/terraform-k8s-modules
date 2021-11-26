
# Module `pgadmin`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `PGADMIN_DEFAULT_EMAIL` (required)
* `PGADMIN_DEFAULT_PASSWORD` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"dpage/pgadmin4:5.6"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `pvc_name` (default `null`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

