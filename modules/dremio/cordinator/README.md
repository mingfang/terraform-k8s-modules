
# Module `dremio/cordinator`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `config_map` (required)
* `env` (default `[]`)
* `image` (default `"dremio/dremio-oss:21.2.0"`)
* `master-cordinator` (required)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9047},{"name":"client","port":31010},{"name":"server","port":45678}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"100Mi"}}`)
* `zookeeper` (required)

## Output Values
* `name`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

