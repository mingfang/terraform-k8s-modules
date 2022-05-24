
# Module `code-server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `additional_containers` (default `[]`)
* `annotations` (default `{}`)
* `args` (default `null`)
* `env` (default `[]`)
* `image` (default `"codercom/code-server:4.3.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `pvc` (default `null`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

