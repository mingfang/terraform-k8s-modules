
# Module `articulate/nginx`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `api` (required)
* `env` (default `[]`)
* `image` (default `"nginx:1.15.10-alpine"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `replicas` (default `1`)
* `ui` (required)

## Output Values
* `deployment`
* `name`
* `port`
* `service`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

