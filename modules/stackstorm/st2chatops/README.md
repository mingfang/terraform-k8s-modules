
# Module `stackstorm/st2chatops`

## Input Variables
* `HUBOT_ADAPTER` (required)
* `HUBOT_LOG_LEVEL` (default `"info"`)
* `ST2_API_URL` (required)
* `ST2_AUTH_URL` (required)
* `ST2_STREAM_URL` (required)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2chatops:latest"`)
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

