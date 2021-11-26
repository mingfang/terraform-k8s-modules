
# Module `scylla`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `env` (default `[]`)
* `image` (default `"scylladb/scylla"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"intra-node","port":7000},{"name":"intra-node-tls","port":7001},{"name":"jmx","port":7199},{"name":"thrift","port":9160},{"name":"cql","port":9042},{"name":"rest","port":10000}]`)
* `replicas` (default `3`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service`

