
# Module `dgraph/dgraph-alpha`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `env` (default `[]`)
* `image` (default `"dgraph/dgraph:v20.03.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `peer` (required)
* `ports` (default `[{"name":"http","port":8080},{"name":"grpc","port":9080},{"name":"grpc-int","port":7080}]`)
* `replicas` (default `1`)
* `storage` (default `null`)
* `storage_class` (default `null`)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

