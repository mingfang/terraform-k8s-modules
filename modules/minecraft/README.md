
# Module `minecraft`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `null`)
* `bungeecord` (default `false`)
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/minecraft:latest"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"minecraft","port":25565},{"name":"frontail","port":9001}]`)
* `storage` (required)
* `storage_class_name` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Child Modules
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

