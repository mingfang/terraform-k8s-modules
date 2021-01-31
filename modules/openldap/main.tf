locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = 1
    ports                = var.ports
    enable_service_links = false
    annotations          = var.annotations

    containers = [
      {
        name  = "openldap"
        image = var.image

        env = concat([
          {
            name  = "LDAP_ORGANISATION"
            value = var.LDAP_ORGANISATION
          },
          {
            name  = "LDAP_DOMAIN"
            value = var.LDAP_DOMAIN
          },
        ], var.env)


        volume_mounts = var.pvc != null ? [
          {
            name       = "data"
            mount_path = "/var/lib/ldap"
          },
        ] : []
      },
    ]

    volumes = var.pvc != null ? [
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc
        }
      },
    ] : []
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
