
# Module `stackstorm/st2stream`

## Input Variables
* `annotations` (default `{}`)
* `config_map` (required)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2stream:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9102}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

