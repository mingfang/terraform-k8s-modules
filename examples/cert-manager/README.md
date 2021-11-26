
# Module `cert-manager`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"cert-manager-example"`)
* `namespace` (default `"cert-manager-example"`)

## Managed Resources
* `k8s_apps_v1_deployment.kuard` from `k8s`
* `k8s_cert_manager_io_v1alpha2_certificate.this` from `k8s`
* `k8s_cert_manager_io_v1alpha2_cluster_issuer.this` from `k8s`
* `k8s_cert_manager_io_v1alpha2_issuer.letsencrypt-prod` from `k8s`
* `k8s_cert_manager_io_v1alpha2_issuer.letsencrypt-staging` from `k8s`
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_core_v1_service.kuard` from `k8s`
* `k8s_extensions_v1beta1_ingress.kuard` from `k8s`

## Child Modules
* `cert-manager` from [../../modules/cert-manager](../../modules/cert-manager)

