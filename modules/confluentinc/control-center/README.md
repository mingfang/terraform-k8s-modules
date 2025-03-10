
# Module `confluentinc/control-center`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CONTROL_CENTER_BOOTSTRAP_SERVERS` (required)
* `CONTROL_CENTER_CONNECT_CLUSTER` (default `null`)
* `CONTROL_CENTER_REPLICATION_FACTOR` (default `1`)
* `CONTROL_CENTER_SCHEMA_REGISTRY_URL` (default `""`)
* `CONTROL_CENTER_ZOOKEEPER_CONNECT` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"confluentinc/cp-enterprise-control-center:6.0.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9021}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

