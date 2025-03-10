
# Module `selenium`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `name` (default `"selenium"`)
* `namespace` (default `"selenium-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.this` from `k8s`

## Child Modules
* `selenium_chrome` from [../../modules/selenium/chrome](../../modules/selenium/chrome)
* `selenium_firefox` from [../../modules/selenium/firefox](../../modules/selenium/firefox)
* `selenium_hub` from [../../modules/selenium/hub](../../modules/selenium/hub)

