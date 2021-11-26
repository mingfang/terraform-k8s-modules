
# Module `mysql`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `MYSQL_DATABASE` (required)
* `MYSQL_PASSWORD` (required)
* `MYSQL_ROOT_HOST` (default `"%"`)
* `MYSQL_ROOT_PASSWORD` (required)
* `MYSQL_USER` (required)
* `TZ` (default `"UTC"`)
* `annotations` (default `{}`)
* `args` (default `["--default-authentication-plugin=caching_sha2_password"]`)
* `default-authentication-plugin` (default `"caching_sha2_password"`): caching_sha2_password or mysql_native_password.
* `env` (default `[]`)
* `image` (default `"mysql:8.0.19"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":3306}]`)
* `replicas` (default `1`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

