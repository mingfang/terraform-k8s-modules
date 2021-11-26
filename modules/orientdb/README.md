
# Module `orientdb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `ORIENTDB_OPTS_MEMORY` (default `"-Xms4G -Xmx4G"`)
* `ORIENTDB_ROOT_PASSWORD` (required)
* `args` (default `""`)
* `distributed` (default `"true"`)
* `env` (default `[]`)
* `image` (default `"orientdb:3.0.23"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":2480},{"name":"binary","port":2424}]`)
* `replicas` (default `3`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Data Resources
* `data.template_file.members` from `template`

## Child Modules
* `statefulset-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/statefulset-service`

