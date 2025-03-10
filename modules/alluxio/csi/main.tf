module "attacher" {
  source    = "../../kubernetes/csi/attacher"
  name      = "${var.name}-attacher"
  namespace = var.namespace
  image     = var.image
  command   = var.command
  args      = var.args
}

module "provisioner" {
  source    = "../../kubernetes/csi/provisioner"
  name      = "${var.name}-provisioner"
  namespace = var.namespace
  image     = var.image
  command   = var.command
  args      = var.args
}

module "nodeplugin" {
  source    = "../../kubernetes/csi/nodeplugin"
  name      = "${var.name}-nodeplugin"
  namespace = var.namespace
  image     = var.image
  command   = var.command
  args      = var.args
}
