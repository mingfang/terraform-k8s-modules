
# Module `grafana/loki`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `alertmanager_url` (default `""`)
* `annotations` (default `{}`)
* `args` (default `[]`)
* `auth_enabled` (default `"true"`)
* `cassandra` (required)
* `config_file` (default `null`)
* `env` (default `[]`)
* `image` (default `"grafana/loki:2.2.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":3100}]`)
* `pvc_name` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"500m","memory":"1Gi"}}`)
* `rules` (default `{}`): map of rule files {tenant=file}

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `config` from [../../kubernetes/config-map](../../kubernetes/config-map)
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rules` from [../../kubernetes/config-map](../../kubernetes/config-map)

