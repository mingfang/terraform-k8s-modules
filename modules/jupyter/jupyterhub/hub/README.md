
# Module `jupyter/jupyterhub/hub`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `OAUTH2_AUTHORIZE_URL` (default `""`)
* `OAUTH2_TOKEN_URL` (default `""`)
* `OAUTH_CALLBACK_URL` (default `""`)
* `annotations` (default `null`)
* `config_map` (required)
* `image` (default `"jupyterhub/k8s-hub:0.8.2"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `port` (default `8081`)
* `proxy_api_service_host` (required)
* `proxy_api_service_port` (required)
* `proxy_public_service_host` (required)
* `proxy_public_service_port` (required)
* `replicas` (default `1`)
* `secret_name` (required)

## Child Modules
* `deployment-service` from [../../../../archetypes/deployment-service](../../../../archetypes/deployment-service)
* `rbac` from [../../../kubernetes/rbac](../../../kubernetes/rbac)

