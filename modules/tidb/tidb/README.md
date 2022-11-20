
# Module `tidb/tidb`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `[]`)
* `command` (default `[]`)
* `configmap` (default `null`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"pingcap/tidb:v6.4.0"`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (default `"tidb"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `pd` (required)
* `ports` (default `[{"name":"tcp1","port":4000},{"name":"tcp2","port":10080}]`)
* `pvc` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `service_account_name` (default `null`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

