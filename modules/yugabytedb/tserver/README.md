
# Module `yugabytedb/tserver`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"yugabytedb/yugabyte:2.2.0.0-b80"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"ysql","port":5433},{"name":"ycql","port":9042},{"name":"yedis","port":6379},{"name":"yb-tserver","port":9000}]`)
* `replicas` (default `3`)
* `storage` (required)
* `storage_class` (required)
* `tserver_master_addrs` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

