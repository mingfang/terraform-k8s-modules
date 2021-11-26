
# Module `articulate/duckling`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `env` (default `[]`)
* `image` (default `"samtecspg/duckling:0.1.6.0"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8000}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `port`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

