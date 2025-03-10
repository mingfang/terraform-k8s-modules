
# Module `openldap`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `LDAP_DOMAIN` (required)
* `LDAP_ORGANISATION` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"osixia/openldap:1.4.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp1","port":389},{"name":"tcp2","port":636}]`)
* `pvc` (default `null`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

