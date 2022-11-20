
# Module `tidb/pd`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `command` (default `[]`)
* `configmap` (default `null`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"pingcap/pd:v6.4.0"`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (default `"pd"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"client","port":2379},{"name":"peer","port":2380}]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `service_account_name` (default `null`)
* `storage` (default `null`)
* `storage_class` (default `null`)
* `volume_claim_template_name` (default `"pvc"`)

## Output Values
* `name`
* `pd`
* `ports`
* `service`
* `statefulset`

## Child Modules
* `statefulset-service` from [../../../archetypes/statefulset-service](../../../archetypes/statefulset-service)

