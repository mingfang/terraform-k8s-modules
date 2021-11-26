
# Module `wordpress`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `WORDPRESS_CONFIG_EXTRA` (default `null`)
* `WORDPRESS_DB_HOST` (required)
* `WORDPRESS_DB_NAME` (required)
* `WORDPRESS_DB_PASSWORD` (required)
* `WORDPRESS_DB_USER` (required)
* `WORDPRESS_DEBUG` (default `null`)
* `WORDPRESS_TABLE_PREFIX` (default `null`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"wordpress"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

