
# Module `kafka-connect`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `bootstrap_servers` (required)
* `env` (default `[]`)
* `image` (default `"debezium/connect"`)
* `name` (required)
* `namespace` (default `null`)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp1","port":8083},{"name":"tcp2","port":5005}]`)
* `replicas` (default `1`)

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

