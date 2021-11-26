
# Module `stackstorm/init-job`

## Input Variables
* `annotations` (default `{}`)
* `config_map` (required)
* `config_map_chatbot_aliases` (default `null`)
* `config_map_rbac_assignments` (required)
* `image` (default `"registry.rebelsoft.com/st2actionrunner:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `stackstorm_packs_configs_pvc_name` (required)
* `stackstorm_packs_pvc_name` (required)

## Child Modules
* `job` from [../../../archetypes/job](../../../archetypes/job)

