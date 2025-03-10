
# Module `metron`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `image` (default `"registry.rebelsoft.com/metron"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `port` (default `80`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Data Resources
* `data.template_file.storm` from `template`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

