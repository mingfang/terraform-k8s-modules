
# Module `confluentinc/connect`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CONNECT_BOOTSTRAP_SERVERS` (required)
* `CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR` (default `1`)
* `CONNECT_KEY_CONVERTER` (default `"io.confluent.connect.avro.AvroConverter"`)
* `CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR` (default `1`)
* `CONNECT_PLUGIN_PATH` (default `"/home/appuser/plugins"`)
* `CONNECT_SCHEMA_REGISTRY_URL` (default `null`)
* `CONNECT_STATUS_STORAGE_REPLICATION_FACTOR` (default `1`)
* `CONNECT_VALUE_CONVERTER` (default `"io.confluent.connect.avro.AvroConverter"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"confluentinc/cp-kafka-connect:6.0.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8083},{"name":"tcp2","port":5005}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

