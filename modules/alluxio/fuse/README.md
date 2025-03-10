
# Module `alluxio/fuse`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `alluxio_master_hostname` (required)
* `alluxio_master_port` (required)
* `image` (default `"alluxio/alluxio-fuse:2.0.1"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)

## Output Values
* `daemonset`
* `name`

## Child Modules
* `daemonset` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/daemonset`

