
# Module `spring-dataflow/skipper-server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `RABBITMQ_HOST` (required)
* `RABBITMQ_PASSWORD` (required)
* `RABBITMQ_PORT` (default `5672`)
* `RABBITMQ_USERNAME` (required)
* `RABBITMQ_VIRTUAL_HOST` (default `"/"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"springcloud/spring-cloud-skipper-server:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":7577}]`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"memory":"2Gi"},"requests":{"cpu":"25m","memory":"80Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

