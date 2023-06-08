
# Module `openfaas`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"openfaas"`)
* `namespace` (default `"openfaas-example"`)
* `storage_class_name` (default `"cephfs"`)

## Managed Resources
* `k8s_core_v1_namespace.functions` from `k8s`
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.alertmanager` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.gateway` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.prometheus` from `k8s`

## Child Modules
* `alertmanager` from [../../modules/openfaas/alertmanager](../../modules/openfaas/alertmanager)
* `crd` from [../../modules/openfaas/crd](../../modules/openfaas/crd)
* `faas-idler` from [../../modules/openfaas/faas-idler](../../modules/openfaas/faas-idler)
* `faas-netes` from [../../modules/openfaas/faas-netes](../../modules/openfaas/faas-netes)
* `gateway` from [../../modules/openfaas/gateway](../../modules/openfaas/gateway)
* `nats` from [../../modules/openfaas/nats](../../modules/openfaas/nats)
* `prometheus` from [../../modules/openfaas/prometheus](../../modules/openfaas/prometheus)
* `queue-worker` from [../../modules/openfaas/queue-worker](../../modules/openfaas/queue-worker)

