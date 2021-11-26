
# Module `openwhisk/invoker`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `KAFKA_HOSTS` (required): openwhisk-kafka-0.openwhisk-kafka.default.svc.cluster.local:9092
* `ZOOKEEPER_HOSTS` (required): openwhisk-zookeeper-0.openwhisk-zookeeper.default.svc.cluster.local:2181
* `annotations` (default `{}`)
* `db_config_name` (required)
* `db_secret_name` (required)
* `env` (default `[]`)
* `image` (default `"openwhisk/invoker:71b7d56"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)
* `whisk_config_name` (required)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../kubernetes/rbac](../../kubernetes/rbac)

