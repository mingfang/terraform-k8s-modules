
# Module `generic-statefulset-service`

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
* `image` (required)
* `image_pull_secrets` (default `[]`)
* `mount_path` (default `"/data"`): pvc mount path
* `name` (required)
* `namespace` (required)
* `node_selector` (default `{}`)
* `overrides` (default `{}`)
* `ports` (default `[]`)
* `post_start_command` (default `null`)
* `pvc_user` (default `"1000"`)
* `pvcs` (default `[]`)
* `replicas` (default `1`)
* `resources` (default `{"requests":{"cpu":"250m","memory":"64Mi"}}`)
* `role_rules` (default `[]`)
* `security_context` (default `null`)
* `service_account_name` (default `null`)
* `sidecars` (default `[]`)
* `storage` (default `null`)
* `storage_class` (default `null`)
* `tolerations` (default `[]`)
* `volume_claim_template_name` (default `"pvc"`)
* `volumes` (default `[]`)

## Output Values
* `name`
* `ports`
* `service`
* `statefulset`

## Managed Resources
* `k8s_core_v1_secret.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.cluster_role_refs` from `k8s`

## Child Modules
* `rbac` from [../../modules/kubernetes/rbac](../../modules/kubernetes/rbac)
* `statefulset-service` from [../../archetypes/statefulset-service](../../archetypes/statefulset-service)

