
# Module `kubernetes/kube-griffiti`

Provider Requirements:
* **k8s:** (any version)
* **template:** (any version)

## Input Variables
* `annotations` (default `{}`)
* `check_existing` (default `false`)
* `env` (default `[]`)
* `image` (default `"hotelsdotcom/kube-graffiti:0.8.5"`)
* `log_level` (default `"info"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"https","port":8443}]`)
* `rbac_cluster_role_rules` (default `[]`): RBAC cluster role rules;  Ensure permission to execute kube-griffiti rules
* `replicas` (default `1`)
* `rules` (required): kube-griffiti rules
* `secret_name` (required): secret containeing TLS certificate

## Output Values
* `deployment`
* `name`
* `service`

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`

## Data Resources
* `data.template_file.config` from `template`

## Child Modules
* `deployment-service` from [../../../archetypes/deployment-service](../../../archetypes/deployment-service)
* `rbac` from [../../../modules/kubernetes/rbac](../../../modules/kubernetes/rbac)

