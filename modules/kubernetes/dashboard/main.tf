//https://github.com/kubernetes/dashboard/blob/master/aio/deploy/recommended.yaml

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "dashboard"
        image = var.image
        env   = var.env
        args = concat([
          "--namespace=${var.namespace}",
          ],
          var.args
        )
        resources = var.resources
      },
    ]
    security_context = {
      allow_privilege_escalation = false
      read_only_root_filesystem  = true
      run_asuser                 = "1001"
      run_asgroup                = "2001"
    }
    service_account_name = module.rbac.name
  }
}

module "kubernetes-dashboard-certs" {
  source    = "../../../modules/kubernetes/secret"
  name      = "kubernetes-dashboard-certs"
  namespace = var.namespace
}

module "kubernetes-dashboard-csrf" {
  source    = "../../../modules/kubernetes/secret"
  name      = "kubernetes-dashboard-csrf"
  namespace = var.namespace

  from-map = {
    csrf = ""
  }
}

resource "k8s_core_v1_secret" "kubernetes-dashboard-key-holder" {
  metadata {
    name      = "kubernetes-dashboard-key-holder"
    namespace = var.namespace
  }

  lifecycle {
    //dashboard will update at runtime
    ignore_changes = [data]
  }
}

module "kubernetes-dashboard-settings" {
  source    = "../../../modules/kubernetes/config-map"
  name      = "kubernetes-dashboard-settings"
  namespace = var.namespace
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}