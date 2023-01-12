
# Module `supabase`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `AWS_ACCESS_KEY_ID` (default `""`)
* `AWS_SECRET_ACCESS_KEY` (default `""`)
* `GOTRUE_SMTP_PASS` (default `null`)
* `GOTRUE_SMTP_USER` (default `null`)
* `name` (default `"supabase"`)
* `namespace` (default `"supabase-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.studio` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.supabase` from `k8s`

## Child Modules
* `gotrue` from [../../modules/supabase/gotrue](../../modules/supabase/gotrue)
* `image_pull_secret` from [../image-pull-secret](../image-pull-secret)
* `kong` from [../../modules/kong](../../modules/kong)
* `kong_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `meta` from [../../modules/supabase/meta](../../modules/supabase/meta)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `postgres_init` from [../../modules/kubernetes/job](../../modules/kubernetes/job)
* `postgres_init_config` from [../../modules/kubernetes/config-map](../../modules/kubernetes/config-map)
* `postgrest` from [../../modules/postgrest](../../modules/postgrest)
* `realtime` from [../../modules/supabase/realtime](../../modules/supabase/realtime)
* `secrets` from [../../modules/kubernetes/secret](../../modules/kubernetes/secret)
* `storage` from [../../modules/supabase/storage](../../modules/supabase/storage)
* `studio` from [../../modules/supabase/studio](../../modules/supabase/studio)

