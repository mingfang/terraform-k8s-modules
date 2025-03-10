
# Module `intellij`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `additional_containers` (default `[]`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `extra_pvcs` (default `[]`)
* `image` (default `"registry.rebelsoft.com/projector-idea-c"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8887}]`)
* `pvc` (default `null`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

