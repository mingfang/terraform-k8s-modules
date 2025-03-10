output "console" {
  value = <<-EOF
    docker run -e GREMLIN_REMOTE_HOSTS=<gremlin server host/ip> -it janusgraph/janusgraph:latest ./bin/gremlin.sh
    :remote connect tinkerpop.server conf/remote.yaml session
    :remote console
    EOF
}