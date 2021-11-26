
# Module `nifi/nifi`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `env` (default `[]`)
* `image` (default `"apache/nifi:latest"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8080}]`)
* `replicas` (default `1`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service`

