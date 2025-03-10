
# Module `grafana/grafana`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `dashboards_config_map_name` (default `null`)
* `datasources_config_map` (default `null`)
* `env` (default `[]`)
* `grafana_ini_config_map_name` (default `null`)
* `image` (default `"grafana/grafana:7.5.2"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":3000}]`)
* `pvc_name` (required)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)

