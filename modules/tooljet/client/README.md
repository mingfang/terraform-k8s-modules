
# Module `tooljet/client`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `SERVER_HOST` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"tooljet/tooljet-client-ce:v1.8.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"125m","memory":"64Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

