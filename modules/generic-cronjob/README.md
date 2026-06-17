
# Module `generic-cronjob`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `annotations` (default `{}`)
* `args` (default `[]`)
* `backoff_limit` (default `null`)
* `cluster_role_refs` (default `[]`)
* `cluster_role_rules` (default `[]`)
* `command` (default `[]`)
* `concurrency_policy` (default `null`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"/config"`)
* `dns_config` (default `null`)
* `dns_policy` (default `null`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `failed_jobs_history_limit` (default `null`)
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
* `restart_policy` (default `null`)
* `role_rules` (default `[]`)
* `schedule` (required)
* `security_context` (default `null`)
* `service_account_name` (default `null`)
* `starting_deadline_seconds` (default `null`)
* `successful_jobs_history_limit` (default `null`)
* `tolerations` (default `[]`)
* `ttl_seconds_after_finished` (default `null`)
* `volumes` (default `[]`)

## Output Values
* `cronjob`
* `name`

## Managed Resources
* `k8s_core_v1_secret.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.cluster_role_refs` from `k8s`

## Child Modules
* `cronjob` from [../../archetypes/cronjob](../../archetypes/cronjob)
* `rbac` from [../../modules/kubernetes/rbac](../../modules/kubernetes/rbac)

