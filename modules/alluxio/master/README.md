
# Module `alluxio/master`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `extra_alluxio_java_opts` (default `""`)
* `image` (default `"alluxio/alluxio:2.0.1"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `ports` (default `[{"name":"tcp-master","port":19998},{"name":"http-master","port":19999},{"name":"tcp-jobmaster","port":20001},{"name":"http-jobmaster","port":20002}]`)
* `replicas` (default `1`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

