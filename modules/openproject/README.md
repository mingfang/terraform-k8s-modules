
# Module `openproject`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `DATABASE_URL` (required): postgres://postgres:p4ssw0rd@db/openproject
* `IMAP_ENABLED` (default `"false"`)
* `OPENPROJECT_CACHE__MEMCACHE__SERVER` (default `null`): cache:11211
* `OPENPROJECT_RAILS__RELATIVE__URL__ROOT` (default `null`)
* `RAILS_CACHE_STORE` (default `null`): memcache
* `USE_PUMA` (default `"true"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"openproject/community:12"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `pvc_name` (required): Volume for /var/openproject/assets
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

