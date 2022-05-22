
# Module `pravega/segmentstore`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CONTROLLER_URL` (required)
* `JAVA_OPTS` (default `""`)
* `ZK_URL` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_map` (default `{}`)
* `image` (default `"pravega/pravega:0.11.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":12345},{"name":"rpc","port":9090}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"125m","memory":"64Mi"}}`)
* `service_account_name` (default `null`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

