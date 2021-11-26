
# Module `bungeecord`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"registry.rebelsoft.com/bungeecord:latest"`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"bungeecord","port":25565}]`)
* `priorities` (default `["lobby"]`)
* `servers` (default `{"lobby":{"address":"lobby:25565","motd":"Just another BungeeCord - Forced Host","restricted":false}}`)
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

