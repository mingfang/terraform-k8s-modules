
# Module `cerbos`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `null`)
* `command` (default `null`)
* `config_map` (default `null`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_map` (default `{}`)
* `image` (default `"ghcr.io/cerbos/cerbos:0.19.0"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `policies_config_map` (default `null`)
* `ports` (default `[{"name":"http","port":3592},{"name":"grpc","port":3593}]`)
* `pvc` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `schemas_config_map` (default `null`)
* `service_account_name` (default `null`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

