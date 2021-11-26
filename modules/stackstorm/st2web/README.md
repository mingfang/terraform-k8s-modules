
# Module `stackstorm/st2web`

## Input Variables
* `ST2_API_URL` (required)
* `ST2_AUTH_URL` (required)
* `ST2_STREAM_URL` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2web:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

