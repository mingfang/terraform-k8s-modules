
# Module `etcd`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ETCD_AUTO_COMPACTION_MODE` (default `"revision"`)
* `ETCD_AUTO_COMPACTION_RETENTION` (default `"1000"`)
* `ETCD_QUOTA_BACKEND_BYTES` (default `"4294967296"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"quay.io/coreos/etcd:v3.5.11"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"client","port":2379},{"name":"peer","port":2380}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
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

