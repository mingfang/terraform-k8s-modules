
# Module `keycloak-provider`

Provider Requirements:
* **keycloak ([mrparkers/keycloak](https://registry.terraform.io/providers/mrparkers/keycloak/latest))** (any version)

## Output Values
* `quickstart_client`

## Managed Resources
* `keycloak_openid_client.quickstart` from `keycloak`
* `keycloak_role.rh_cr_read` from `keycloak`

## Data Resources
* `data.keycloak_realm.rebelsoft` from `keycloak`
* `data.keycloak_role.foo` from `keycloak`

