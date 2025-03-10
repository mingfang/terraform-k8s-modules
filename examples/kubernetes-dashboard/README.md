
# Module `kubernetes-dashboard`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"dashboard"`)
* `namespace` (default `"dashboard-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.nginx` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.cluster-admin` from `k8s`

## Child Modules
* `dashboard` from [../../modules/kubernetes/dashboard](../../modules/kubernetes/dashboard)
* `dashboard-metrics-scraper` from [../../modules/kubernetes/dashboard-metrics-scraper](../../modules/kubernetes/dashboard-metrics-scraper)

