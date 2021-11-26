
# Module `zeebe/zeebe`

## Input Variables
* `JAVA_TOOL_OPTIONS` (default `""`)
* `ZEEBE_BROKER_CLUSTER_REPLICATIONFACTOR` (default `1`)
* `ZEEBE_LOG_LEVEL` (default `"info"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"camunda/zeebe:0.23.2"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"gateway","port":26500},{"name":"command","port":26501},{"name":"internal","port":26502},{"name":"monitoring","port":9600},{"name":"hazelcast","port":5701}]`)
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

