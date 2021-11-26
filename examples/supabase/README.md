
# Module `supabase`

Provider Requirements:
* **k8s ([mingfang/k8s](https://registry.terraform.io/providers/mingfang/k8s/latest))** (any version)

## Input Variables
* `GOTRUE_SMTP_PASS` (required)
* `GOTRUE_SMTP_USER` (required)
* `name` (default `"supabase"`)
* `namespace` (default `"supabase-example"`)

## Managed Resources
* `k8s_core_v1_namespace.this` from `k8s`
* `k8s_networking_k8s_io_v1beta1_ingress.kong` from `k8s`

## Child Modules
* `gotrue` from [../../modules/supabase/gotrue](../../modules/supabase/gotrue)
* `kong` from [../../modules/supabase/kong](../../modules/supabase/kong)
* `postgres` from [../../modules/postgres](../../modules/postgres)
* `postgrest` from [../../modules/postgrest](../../modules/postgrest)
* `realtime` from [../../modules/supabase/realtime](../../modules/supabase/realtime)

