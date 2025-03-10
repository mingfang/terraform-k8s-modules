module "init-job" {
  source    = "../../kubernetes/job"
  name      = "${var.name}-init"
  namespace = var.namespace

  image     = var.image
  command = [
    "/bin/bash",
    "-c",
    <<-EOF
    postal initialize
    postal upgrade
    EOF
  ]

  configmap = var.configmap
  secret = var.secret
}
