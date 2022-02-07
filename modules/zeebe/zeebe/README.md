
# Module `zeebe/zeebe`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `JAVA_TOOL_OPTIONS` (default `""`)
* `ZEEBE_BROKER_CLUSTER_REPLICATIONFACTOR` (default `1`)
* `ZEEBE_LOG_LEVEL` (default `"info"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"camunda/zeebe:1.3.3"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"gateway","port":26500},{"name":"command","port":26501},{"name":"internal","port":26502},{"name":"monitoring","port":9600}]`)
* `replicas` (default `1`)
* `resources` (default `{"limits":{"memory":"4Gi"},"requests":{"cpu":"500m","memory":"1Gi"}}`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

