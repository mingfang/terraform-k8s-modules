
# Module `drools`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"drools"`)
* `namespace` (default `"drools-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_extensions_v1beta1_ingress.this` from `k8s`

## Child Modules
* `kie-server` from [../../modules/drools/kie-server](../../modules/drools/kie-server)
* `kie-server2` from [../../modules/drools/kie-server](../../modules/drools/kie-server)
* `workbench` from [../../modules/drools/workbench](../../modules/drools/workbench)

