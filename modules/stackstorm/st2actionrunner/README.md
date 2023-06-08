
# Module `stackstorm/st2actionrunner`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `additional_containers` (default `[]`)
* `annotations` (default `{}`)
* `config_map` (required)
* `env` (default `[]`)
* `image` (default `"stackstorm/st2actionrunner:3.6.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `stackstorm_keys_pvc_name` (required)
* `stackstorm_packs_configs_pvc_name` (required)
* `stackstorm_packs_pvc_name` (required)
* `stackstorm_ssh_pvc_name` (required)
* `stackstorm_virtualenvs_pvc_name` (required)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

