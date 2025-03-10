
# Module `confluentinc/kafka`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `KAFKA_LOG4J_LOGGERS` (default `"kafka.controller=INFO,kafka.producer.async.DefaultEventHandler=INFO,state.change.logger=INFO"`)
* `KAFKA_METRIC_REPORTERS` (default `"io.confluent.metrics.reporter.ConfluentMetricsReporter"`)
* `KAFKA_ZOOKEEPER_CONNECT` (required): Zookeeper URL, e.g. zookeeper:2181
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"confluentinc/cp-enterprise-kafka:6.0.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":9092}]`)
* `replicas` (default `1`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

