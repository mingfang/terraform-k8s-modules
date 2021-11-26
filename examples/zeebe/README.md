
# Module `zeebe`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"zeebe"`)
* `namespace` (default `"zeebe-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.simple-monitor` from `k8s`

## Child Modules
* `http-worker` from [../../modules/zeebe/http-worker](../../modules/zeebe/http-worker)
* `simple-monitor` from [../../modules/zeebe/simple-monitor](../../modules/zeebe/simple-monitor)
* `zeebe` from [../../modules/zeebe/zeebe](../../modules/zeebe/zeebe)

