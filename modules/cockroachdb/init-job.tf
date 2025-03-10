locals {
  host = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
}

module "init-job" {
  source    = "../kubernetes/job"
  name      = "${var.name}-init"
  namespace = var.namespace
  image     = var.image
  command = [
    "/bin/bash",
    "-cx",
    <<-EOF
    until curl ${local.host}:8080/health; do
      sleep 10
    done
    /cockroach/cockroach init \
      --logtostderr \
      --insecure \
      --cluster-name ${local.cluster-name} \
      --host ${local.host}
    EOF
  ]
}