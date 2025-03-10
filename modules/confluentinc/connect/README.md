
# Module `confluentinc/connect`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `CONNECT_BOOTSTRAP_SERVERS` (required)
* `CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR` (default `1`)
* `CONNECT_KEY_CONVERTER` (default `"io.confluent.connect.avro.AvroConverter"`)
* `CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR` (default `1`)
* `CONNECT_PLUGIN_PATH` (default `"/usr/share/confluent-hub-components"`)
* `CONNECT_SCHEMA_REGISTRY_URL` (default `null`)
* `CONNECT_STATUS_STORAGE_REPLICATION_FACTOR` (default `1`)
* `CONNECT_VALUE_CONVERTER` (default `"io.confluent.connect.avro.AvroConverter"`)
* `annotations` (default `{}`)
* `configmap` (default `null`): keys are mounted to /etc/kafka
* `env` (default `[]`)
* `image` (default `"confluentinc/cp-kafka-connect:6.2.4"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `plugins` (default `[]`): install list of confluent-hub plugins
* `ports` (default `[{"name":"http","port":8083},{"name":"tcp2","port":5005}]`)
* `pvc` (default `null`): install plugins into this volume
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `init-job` from [../../kubernetes/job](../../kubernetes/job)

