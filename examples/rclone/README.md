
# Module `rclone`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `is_create_namespace` (default `true`)
* `name` (default `"rclone"`)
* `namespace` (default `"rclone-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.nginx` from `k8s`

## Child Modules
* `config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `namespace` from [../namespace](../namespace)
* `nginx` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

