
# Module `generic-daemonset`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `[]`)
* `cluster_role_refs` (default `[]`)
* `cluster_role_rules` (default `[]`)
* `command` (default `[]`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"/config"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `host_ipc` (default `null`)
* `host_network` (default `null`)
* `host_pid` (default `null`)
* `image` (required)
* `image_pull_secrets` (default `[]`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `post_start_command` (default `null`)
* `pvc_user` (default `"1000"`)
* `pvcs` (default `[]`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `role_rules` (default `[]`)
* `security_context` (default `null`)
* `service_account_name` (default `null`)
* `sidecars` (default `[]`)
* `tolerations` (default `[]`)
* `volumes` (default `[]`)

## Output Values
* `daemonset`
* `name`

## Managed Resources
* `k8s_core_v1_secret.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.cluster_role_refs` from `k8s`

## Child Modules
* `daemonset` from [../../archetypes/daemonset](../../archetypes/daemonset)
* `rbac` from [../../modules/kubernetes/rbac](../../modules/kubernetes/rbac)

