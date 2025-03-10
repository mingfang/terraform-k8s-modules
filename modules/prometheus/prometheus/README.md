
# Module `prometheus/prometheus`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)
* **template:** (any version)

## Input Variables
* `annotations` (default `{}`)
* `config_file` (default `""`)
* `env` (default `[]`)
* `image` (default `"prom/prometheus:v2.16.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":9090}]`)
* `replicas` (default `1`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `port`
* `service`
* `statefulset`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Data Resources
* `data.template_file.config` from `template`

## Child Modules
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

