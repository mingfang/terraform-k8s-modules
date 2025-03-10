
# Module `dgraph/dgraph-zero`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `env` (default `[]`)
* `image` (default `"dgraph/dgraph:v20.03.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":6080},{"name":"grpc","port":5080}]`)
* `replicas` (default `1`)
* `storage` (default `null`)
* `storage_class` (default `null`)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `peer`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

