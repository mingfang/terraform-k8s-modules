
# Module `kafka-connect-ui`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"landoop/kafka-connect-ui"`)
* `kafka_connect` (required)
* `name` (required)
* `namespace` (default `null`)
* `node_selector` (default `{}`)
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

