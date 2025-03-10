locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "metrics-scraper"
        image = var.image
        volume_mounts = [
          {
            name       = "tmp"
            mount_path = "/tmp"
          }
        ]
      }
    ]
    security_context = {
      allow_privilege_escalation = false
      read_only_root_filesystem  = true
      run_asuser                 = "1001"
      run_asgroup                = "2001"
    }
    service_account_name = module.rbac.name
    volumes = [
      {
        name = "tmp"
        empty_dir = {
          "" = ""
        }
      }
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}