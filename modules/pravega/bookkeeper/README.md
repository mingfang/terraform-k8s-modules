
# Module `pravega/bookkeeper`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ZK_URL` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"pravega/bookkeeper:0.11.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":3181}]`)
* `pvc` (default `"pvc"`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"125m","memory":"64Mi"}}`)
* `storage` (required)
* `storage_class` (required)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

