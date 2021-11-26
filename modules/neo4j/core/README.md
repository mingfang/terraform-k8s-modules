
# Module `neo4j/core`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `NEO4J_ACCEPT_LICENSE_AGREEMENT` (default `"NO"`)
* `annotations` (default `{}`)
* `env` (default `[]`)
* `image` (default `"neo4j:4.1.1-enterprise"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":7474},{"name":"bolt","port":7687}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"1Gi"}}`)
* `storage` (required)
* `storage_class` (required)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `discovery_members`
* `name`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

