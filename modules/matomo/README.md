
# Module `matomo`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `MATOMO_DATABASE_DBNAME` (default `null`)
* `MATOMO_DATABASE_HOST` (required)
* `MATOMO_DATABASE_PASSWORD` (required)
* `MATOMO_DATABASE_USERNAME` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"matomo:3.14.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `pvc_name` (required)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

