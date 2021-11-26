
# Module `citus/worker`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `coordinator` (required): coordinator hostname
* `env` (default `[]`)
* `image` (default `"citusdata/citus:9.4.0"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp","port":5432}]`)
* `replicas` (default `3`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"1Gi"}}`)
* `secret` (required): secret containing the password
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

