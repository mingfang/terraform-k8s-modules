
# Module `generic-deployment-service`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `_lifecycle` (default `null`)
* `annotations` (default `{}`)
* `args` (default `[]`)
* `cluster_role_refs` (default `[]`)
* `cluster_role_rules` (default `[]`)
* `command` (default `[]`)
* `config_files` (default `null`)
* `config_files_mount_path` (default `"/config"`)
* `configmap` (default `null`)
* `configmap_mount_path` (default `"/config"`)
* `env` (default `[]`)
* `env_file` (default `null`)
* `env_from` (default `[]`)
* `env_map` (default `{}`)
* `image` (required)
* `image_pull_secrets` (default `[]`)
* `init_containers` (default `[]`)
* `liveness_probe` (default `null`)
* `max_replicas` (default `1`)
* `min_replicas` (default `1`)
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[]`)
* `ports_map` (default `{}`)
* `pvc_user` (default `""`)
* `pvcs` (default `[]`)
* `readiness_probe` (default `null`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `role_rules` (default `[]`)
* `security_context` (default `null`)
* `service_account_name` (default `null`)
* `sidecars` (default `[]`)
* `startup_probe` (default `null`)
* `strategy` (default `null`)
* `target_cpu_utilization_percentage` (default `50`)
* `tolerations` (default `[]`)
* `volumes` (default `[]`)

## Output Values
* `deployment`
* `name`
* `ports`
* `ports_map`
* `service`

## Managed Resources
* `k8s_autoscaling_v1_horizontal_pod_autoscaler.this` from `k8s`
* `k8s_core_v1_secret.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.cluster_role_refs` from `k8s`

## Child Modules
* `config_files` from [../kubernetes/config-map](../kubernetes/config-map)
* `deployment-service` from [../../archetypes/deployment-service](../../archetypes/deployment-service)
* `rbac` from [../../modules/kubernetes/rbac](../../modules/kubernetes/rbac)

