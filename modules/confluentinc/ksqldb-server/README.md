
# Module `confluentinc/ksqldb-server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `KSQL_BOOTSTRAP_SERVERS` (required)
* `KSQL_CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR` (default `1`)
* `KSQL_CONNECT_KEY_CONVERTER` (default `"io.confluent.connect.avro.AvroConverter"`)
* `KSQL_CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR` (default `1`)
* `KSQL_CONNECT_STATUS_STORAGE_REPLICATION_FACTOR` (default `1`)
* `KSQL_CONNECT_VALUE_CONVERTER` (default `"io.confluent.connect.avro.AvroConverter"`)
* `KSQL_KSQL_CONNECT_URL` (default `null`)
* `KSQL_KSQL_SCHEMA_REGISTRY_URL` (default `null`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"confluentinc/ksqldb-server:0.12.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8088}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

