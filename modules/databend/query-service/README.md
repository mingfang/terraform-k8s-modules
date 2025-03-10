
# Module `databend/query-service`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `META_ENDPOINTS` (required)
* `annotations` (default `{}`)
* `args` (default `[]`)
* `command` (default `["/databend-query"]`)
* `configmap` (default `null`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (default `"datafuselabs/databend-query:latest"`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (default `"query-service"`)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8000},{"name":"admin","port":8080},{"name":"metrics","port":7070},{"name":"msql","port":3307},{"name":"clickhouse","port":8124},{"name":"flight","port":9090}]`)
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

