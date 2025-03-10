module "example-user-code" {
  source    = "../../modules/dagster/user-repository"
  name      = "example-user-code"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "docker.io/dagster/user-code-example:latest"
  command   = [
    "/bin/bash",
    "-cx",
    <<-EOF
    dagster api grpc -h 0.0.0.0 -p 4000 -f /example_project/example_repo/repo.py
    EOF
  ]
}

module "dagster-dbt" {
  source    = "../../modules/dagster/user-repository"
  name      = "dagster-dbt"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  image     = "registry.rebelsoft.com/dagster-dbt"
}
