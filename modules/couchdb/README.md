
# Module `couchdb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `NODENAME` (default `null`): defaults to pod name
* `annotations` (default `{}`)
* `db_password_key` (default `""`)
* `db_secret_name` (default `""`)
* `db_username_key` (default `""`)
* `env` (default `[]`)
* `image` (default `"apache/couchdb:2.3"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":5984}]`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"memory":"1Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}`)
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

