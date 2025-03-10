
# Module `drools/kie-server`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `controller_pwd` (default `"admin12345"`)
* `controller_url` (required)
* `controller_user` (default `"admin"`)
* `image` (default `"jboss/kie-server:7.27.0.Final"`)
* `kie_server_id` (default `"default"`)
* `kie_server_pwd` (default `"kieserver1!"`)
* `kie_server_user` (default `"kieserver"`)
* `maven_pwd` (default `"admin12345"`)
* `maven_repo_url` (required)
* `maven_user` (default `"admin"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

