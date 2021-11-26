
# Module `weave-scope/app`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"docker.io/weaveworks/scope:1.13.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":4040}]`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"memory":"2Gi"},"requests":{"cpu":"25m","memory":"80Mi"}}`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

