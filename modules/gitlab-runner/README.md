
# Module `gitlab-runner`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `null`)
* `env` (default `[]`)
* `gitlab_url` (required)
* `image` (default `"gitlab/gitlab-runner:latest"`)
* `name` (required)
* `namespace` (default `null`)
* `node_selector` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"http","port":80}]`)
* `registration_token` (required)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_config_map.this` from `k8s`
* `k8s_core_v1_service_account.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.this` from `k8s`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

