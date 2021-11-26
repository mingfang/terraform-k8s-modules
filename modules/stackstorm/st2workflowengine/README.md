
# Module `stackstorm/st2workflowengine`

## Input Variables
* `annotations` (default `{}`)
* `config_map` (required)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2workflowengine:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `stackstorm_keys_pvc_name` (required)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

