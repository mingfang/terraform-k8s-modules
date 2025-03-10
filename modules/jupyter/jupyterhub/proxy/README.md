
# Module `jupyter/jupyterhub/proxy`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `null`)
* `hub_service_host` (required)
* `hub_service_port` (required)
* `image` (default `"jupyterhub/configurable-http-proxy:3.0.0"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":8000},{"name":"api","port":8001}]`)
* `replicas` (default `1`)
* `secret_name` (required)

## Output Values
* `service`

## Child Modules
* `deployment-service` from [../../../../archetypes/deployment-service](../../../../archetypes/deployment-service)

