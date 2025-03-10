
# Module `goldpinger`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (required)
* `namespace` (default `null`)

## Output Values
* `name`
* `service`

## Managed Resources
* `k8s_apps_v1_daemon_set.goldpinger` from `k8s`
* `k8s_core_v1_service.goldpinger` from `k8s`
* `k8s_core_v1_service_account.goldpinger_serviceaccount` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role.goldpinger_clusterrole` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1beta1_cluster_role_binding.goldpinger_clusterrolebinding` from `k8s`

