
# Module `sonarqube`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"sonarqube"`)
* `namespace` (default `"sonarqube-example"`)
* `replicas` (default `1`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_persistent_volume_claim.sonarqube_data` from `k8s`
* `k8s_core_v1_persistent_volume_claim.sonarqube_extensions` from `k8s`
* `k8s_core_v1_persistent_volume_claim.sonarqube_logs` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `sonarqube` from [../../modules/sonarqube](../../modules/sonarqube)

