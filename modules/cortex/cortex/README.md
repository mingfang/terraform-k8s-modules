
# Module `cortex/cortex`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `auth_enabled` (default `"true"`)
* `cassandra` (required)
* `config_file` (default `""`)
* `env` (default `[]`)
* `extra-args` (default `[]`)
* `image` (default `"quay.io/cortexproject/cortex:v1.2.0"`)
* `keyspace` (default `"cortex"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9009}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"1Gi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

