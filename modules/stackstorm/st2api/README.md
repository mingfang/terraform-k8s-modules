
# Module `stackstorm/st2api`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `ST2_API_URL` (required)
* `ST2_AUTH_URL` (required)
* `ST2_STREAM_URL` (required)
* `annotations` (default `{}`)
* `config_map` (required)
* `config_map_chatbot_aliases` (required)
* `config_map_rbac_assignments` (required)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2api:latest"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9101}]`)
* `replicas` (default `1`)
* `stackstorm_keys_pvc_name` (required)
* `stackstorm_packs_configs_pvc_name` (required)
* `stackstorm_packs_pvc_name` (required)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

