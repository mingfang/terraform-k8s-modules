
# Module `arangodb/coordinator`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `cluster-agency-endpoints` (required)
* `env` (default `[]`)
* `image` (default `"arangodb/arangodb:3.7.8"`)
* `jwt-secret-keyfile` (required)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":8529}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"100m","memory":"128Mi"}}`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

