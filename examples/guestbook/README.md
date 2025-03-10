
# Module `guestbook`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Managed Resources
* `k8s_apps_v1_deployment.frontend` from `k8s`
* `k8s_apps_v1_deployment.redis-master` from `k8s`
* `k8s_apps_v1_deployment.redis-slave` from `k8s`
* `k8s_core_v1_service.frontend` from `k8s`
* `k8s_core_v1_service.redis-master` from `k8s`
* `k8s_core_v1_service.redis-slave` from `k8s`

