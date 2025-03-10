
# Module `eclipse-che`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"che"`)
* `namespace` (default `"eclipse-example"`)
* `storage_class_name` (default `"cephfs"`)
* `user_storage` (default `"1Gi"`)

## Managed Resources
* `k8s_cert_manager_io_v1alpha2_certificate.wildcard` from `k8s`
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.che` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.devfile-registry` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.plugin-registry` from `k8s`

## Data Resources
* `data.k8s_core_v1_secret.wildcard` from `k8s`

## Child Modules
* `devfile-registry` from [../../modules/eclipse-che/devfile-registry](../../modules/eclipse-che/devfile-registry)
* `eclipse-che` from [../../modules/eclipse-che/eclipse-che](../../modules/eclipse-che/eclipse-che)
* `plugin-registry` from [../../modules/eclipse-che/plugin-registry](../../modules/eclipse-che/plugin-registry)
* `postgres` from [../../modules/postgres](../../modules/postgres)

