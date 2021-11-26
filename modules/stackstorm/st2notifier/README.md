
# Module `stackstorm/st2notifier`

## Input Variables
* `annotations` (default `{}`)
* `config_map` (required)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2notifier:latest"`)
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

