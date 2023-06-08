
# Module `superset`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `config_configmap` (default `null`)
* `datasources_configmap` (default `null`)
* `env` (default `[]`)
* `image` (default `"apache/superset:2.0.1"`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8088}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `ports`
* `service`

## Child Modules
* `datasources-job` from [../kubernetes/job](../kubernetes/job)
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)
* `init-job` from [../kubernetes/job](../kubernetes/job)

