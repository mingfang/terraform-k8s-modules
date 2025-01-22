output "name" {
  value = k8s_batch_v1_cron_job.this.metadata.0.name
}

output "cronjob" {
  value = k8s_batch_v1_cron_job.this
}
