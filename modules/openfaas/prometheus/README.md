
# Module `openfaas/prometheus`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `function_namespace` (default `null`)
* `image` (default `"prom/prometheus:v2.11.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9090}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"50m","memory":"512Mi"}}`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

