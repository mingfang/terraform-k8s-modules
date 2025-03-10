
# Module `frappe`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"frappe"`)
* `namespace` (default `"frappe-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.dev` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.dev` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.intellij` from `k8s`
* `k8s_rbac_authorization_k8s_io_v1_role_binding.admin` from `k8s`

## Child Modules
* `dev-server` from [../../modules/frappe/dev-server](../../modules/frappe/dev-server)
* `intellij` from [../../modules/intellij](../../modules/intellij)
* `mysql` from [../../modules/mysql](../../modules/mysql)
* `redis-cache` from [../../modules/redis](../../modules/redis)
* `redis-queue` from [../../modules/redis](../../modules/redis)
* `redis-socketio` from [../../modules/redis](../../modules/redis)

