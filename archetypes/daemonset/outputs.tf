output "name" {
  value = k8s_apps_v1_daemon_set.this.metadata.0.name
}

output "daemonset" {
  value = k8s_apps_v1_daemon_set.this
}
