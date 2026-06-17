
# Module `vllm`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `HUGGING_FACE_HUB_TOKEN` (required)
* `is_create_namespace` (default `true`)
* `name` (default `"vllm"`)
* `namespace` (default `"vllm-example"`)

## Managed Resources
* `k8s_networking_k8s_io_v1_ingress.vllm` from `k8s`

## Child Modules
* `namespace` from [../namespace](../namespace)
* `vllm` from [../../modules/generic-deployment-service](../../modules/generic-deployment-service)

