
# Module `nifi/minifi-c2`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `NIFI_REST_API_URL` (required)
* `env` (default `[]`)
* `image` (default `"apache/nifi-minifi-c2:0.5.0"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":10080}]`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Managed Resources
* `k8s_core_v1_config_map.context` from `k8s`

## Child Modules
* `statefulset-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service`

