
# Module `spring-dataflow/dataflow-server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"springcloud/spring-cloud-dataflow-server:2.7.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":9393}]`)
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

