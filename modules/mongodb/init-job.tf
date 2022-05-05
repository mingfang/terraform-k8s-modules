locals {
  host = "${var.name}-0.${var.name}.${var.namespace}.svc.cluster.local"
  members = join(", ",
    [
      for i in range(0, var.replicas) :
      "{ _id: ${i}, host: \"${var.name}-${i}.${var.name}.${var.namespace}.svc.cluster.local:${var.ports[0].port}\" }"
    ]
  )
}

module "init-job" {
  source    = "../kubernetes/job"
  name      = "${var.name}-init"
  namespace = var.namespace
  image     = var.image
  command = [
    "/bin/bash",
    "-c",
    <<-EOF
    until mongo --host ${local.host} -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --eval 'if (!rs.status().ok) rs.initiate({ _id: "${var.replica_set}", members: [${local.members}]});'; do
      sleep 3;
    done
    for i in $(seq $FROMHERE 1 ${var.replicas - 1}); do
      member="${var.name}-$i.${var.name}.${var.namespace}.svc.cluster.local:${var.ports[0].port}"
      mongo --host ${local.host}  -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --eval "rs.add( { _id: $i, host: \"$member\" } )"
    done
    EOF
  ]

  env = concat([
    {
      name  = "MONGO_INITDB_ROOT_USERNAME"
      value = var.MONGO_INITDB_ROOT_USERNAME
    },
    {
      name  = "MONGO_INITDB_ROOT_PASSWORD"
      value = var.MONGO_INITDB_ROOT_PASSWORD
    },
  ], var.env)
}
