
# Module `drools/workbench`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `image` (default `"jboss/business-central-workbench:7.27.0.Final"`)
* `name` (required)
* `namespace` (default `null`)
* `overrides` (default `{}`)
* `replicas` (default `1`)
* `users` (default `[{"password":"admin12345","roles":"admin,analyst,kiemgmt,rest-all","user":"admin"},{"password":"kieserver1!","roles":"kie-server","user":"kieserver"},{"password":"analyst12345","roles":"analyst","user":"analyst"},{"password":"developer12345","roles":"developer","user":"developer"},{"password":"manager12345","roles":"manager","user":"manager"},{"password":"user12345","roles":"user","user":"user"}]`)

## Output Values
* `deployment`
* `name`
* `service`

## Child Modules
* `deployment-service` from `git::https://github.com/mingfang/terraform-k8s-modules.git//archetypes/deployment-service`

