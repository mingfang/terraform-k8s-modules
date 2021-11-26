
# Module `kubernetes/rbac`

Provider Requirements:
* **k8s (`mingfang/k8s`):** (any version)

## Input Variables
* `cluster_role_rules` (default `null`)
* `name` (required)
* `namespace` (required)
* `overrides` (default `{}`)
* `role_rules` (default `null`)

## Output Values
* `name`
* `service_account`

## Managed Resources
* `k8s_core_v1_service_account.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_role.this` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_role_binding.this` from `k8s`

