locals {
  labels = lookup(var.parameters, "labels", {
    name = var.parameters.name
  })

  k8s_batch_v1_job_parameters = merge({ labels = local.labels }, var.parameters)
}
