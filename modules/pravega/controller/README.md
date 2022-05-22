
# Module `pravega/controller`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `JAVA_OPTS` (default `""`)
* `SERVICE_HOST_IP` (required)
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
* `ports` (default `[{"name":"rest","port":10080},{"name":"rpc","port":9090}]`)
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

