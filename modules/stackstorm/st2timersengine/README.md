
# Module `stackstorm/st2timersengine`

## Input Variables
* `annotations` (default `{}`)
* `config_map` (required)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2timersengine:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

