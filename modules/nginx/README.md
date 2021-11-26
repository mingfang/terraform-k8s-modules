
# Module `nginx`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `default-conf` (default `null`)
* `env` (default `[]`)
* `image` (default `"nginx:1.17.8"`)
* `name` (required)
* `namespace` (required)
* `nginx-conf` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Child Modules
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)

