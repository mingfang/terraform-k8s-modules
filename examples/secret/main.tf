/*
Demonstrate hide of sensitive data in the Terraform plan.

>terraform plan
  # k8s_core_v1_secret.mysecret will be created
  + resource "k8s_core_v1_secret" "mysecret" {
      + data        = (sensitive value)
      + id          = (known after apply)
      + immutable   = (known after apply)
      + string_data = (known after apply)
      + type        = (known after apply)

      + metadata {
          + annotations                   = (known after apply)
          + creation_timestamp            = (known after apply)
          + deletion_grace_period_seconds = (known after apply)
          + deletion_timestamp            = (known after apply)
          + labels                        = (known after apply)
          + name                          = "mysecret"
          + namespace                     = (known after apply)
          + resource_version              = (known after apply)
          + self_link                     = (known after apply)
          + uid                           = (known after apply)
        }
    }
*/

resource "k8s_core_v1_secret" "mysecret" {
  metadata {
    name = "mysecret"
  }

  data = {
    "secret" = base64encode("hideme")
  }
}