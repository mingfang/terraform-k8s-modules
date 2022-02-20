locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "mongodb"
        image = var.image

        command = [
          "bash",
          "-cx",
          <<-EOF
          mkdir -p /etc/mongodb
          cp /dev/shm/mongodb/keyfile /etc/mongodb/keyfile
          chown mongodb:mongodb /etc/mongodb/keyfile
          chmod 400 /etc/mongodb/keyfile
          docker-entrypoint.sh --bind_ip_all --replSet ${var.replica_set} -keyFile /etc/mongodb/keyfile
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
          {
            name  = "MONGO_INITDB_DATABASE"
            value = var.MONGO_INITDB_DATABASE
          },
        ], var.env)


        volume_mounts = [
          {
            name       = "keyfile"
            mount_path = "/dev/shm/mongodb/keyfile"
            sub_path   = "keyfile"
          },
          {
            name       = var.volume_claim_template_name
            mount_path = "/data/db"
          },
        ]
      },
    ]

    volumes = [
      {
        name = "keyfile"
        secret = {
          secret_name = var.keyfile_secret
        }
      }
    ]

    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ]
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
