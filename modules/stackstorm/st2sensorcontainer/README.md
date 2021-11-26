
# Module `stackstorm/st2sensorcontainer`

## Input Variables
* `annotations` (default `{}`)
* `config_map` (required)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2sensorcontainer:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `stackstorm_packs_configs_pvc_name` (required)
* `stackstorm_packs_pvc_name` (required)
* `stackstorm_virtualenvs_pvc_name` (required)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

