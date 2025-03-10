
# Module `opa`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"openpolicyagent/opa:0.18.0"`)
* `log-level` (default `"info"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `policies_config_map` (required): Rego policy files
* `ports` (default `[{"name":"http","port":443}]`)
* `replicas` (default `1`)
* `secret_name` (required): secret containing TLS certificate

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

