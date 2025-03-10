
# Module `confluentinc/schema-registry`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `SCHEMA_REGISTRY_KAFKASTORE_BOOTSTRAP_SERVERS` (default `null`): Kafka Bootstrap Servers.
* `SCHEMA_REGISTRY_KAFKASTORE_CONNECTION_URL` (default `null`): ZooKeeper URL for the Kafka cluster.
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"confluentinc/cp-schema-registry:6.0.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8081}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

