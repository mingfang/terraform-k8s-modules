
# Module `rabbitmq`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `RABBITMQ_ERLANG_COOKIE` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"rabbitmq:3.8.9-management"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"amqp","port":5672},{"name":"management","port":15672},{"name":"stomp","port":61613},{"name":"stomp-web","port":15674}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"1Gi"}}`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `config` from [../kubernetes/config-map](../kubernetes/config-map)
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

