locals {
  env = concat([
    {
      name = "HOSTNAME"

      value_from = {
        field_ref = {
          field_path = "metadata.name"
        }
      }
    },
    {
      name = "POD_IP"

      value_from = {
        field_ref = {
          field_path = "status.podIP"
        }
      }
    },
    {
      name  = "SITE_NAME"
      value = var.SITE_NAME
    },
    {
      name  = "AUTO_MIGRATE"
      value = var.AUTO_MIGRATE
    },
    {
      name  = "GET_APPS"
      value = var.GET_APPS
    },
    {
      name  = "ADMIN_PASSWORD"
      value = var.ADMIN_PASSWORD
    },
    {
      name  = "POSTGRES_HOST"
      value = var.POSTGRES_HOST
    },
    {
      name  = "POSTGRES_PASSWORD"
      value = var.POSTGRES_PASSWORD
    },
    {
      name  = "MARIADB_HOST"
      value = var.MARIADB_HOST
    },
    {
      name  = "MYSQL_ROOT_PASSWORD"
      value = var.MYSQL_ROOT_PASSWORD
    },
    {
      name  = "DB_HOST"
      value = coalesce(var.MARIADB_HOST, var.POSTGRES_HOST)
    },
    {
      name  = "DB_ROOT_USER"
      value = var.DB_ROOT_USER
    },
    {
      name  = "DB_PORT"
      value = var.DB_PORT
    },
    {
      name  = "REDIS_CACHE"
      value = var.REDIS_CACHE
    },
    {
      name  = "REDIS_QUEUE"
      value = var.REDIS_QUEUE
    },
    {
      name  = "REDIS_SOCKETIO"
      value = var.REDIS_SOCKETIO
    },
    {
      name  = "SOCKETIO_PORT"
      value = var.SOCKETIO_PORT
    },
    {
      name  = "FRAPPE_PORT"
      value = var.ports[0].port
    },
  ], var.env)

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "dev-server"
        image = var.image
        command = [
          "bash",
          "-cx",
          <<-EOF
          bench set-mariadb-host $MARIADB_HOST
          bench set-redis-cache-host $REDIS_CACHE
          bench set-redis-queue-host $REDIS_QUEUE
          bench set-redis-socketio-host $REDIS_SOCKETIO
          bench set-config -g socketio_port $SOCKETIO_PORT
          bench set-config -g serve_default_site true
          bench set-config -g developer_mode 1

          # force needed when sites dir exists but empty
          bench new-site $SITE_NAME \
            --mariadb-root-password $MYSQL_ROOT_PASSWORD \
            --db-host $MARIADB_HOST \
            --db-name $SITE_NAME \
            --admin-password $ADMIN_PASSWORD \
            --no-mariadb-socket \
            $([ ! -f sites/$SITE_NAME/site_config.json ] && echo "--force") || true
          bench use $SITE_NAME

          INSTALL_APPS=$(find /home/frappe/frappe-bench/apps -mindepth 1 -maxdepth 1 -type d -printf '%f ')
          bench install-app $INSTALL_APPS

          if [[ ! -z "$AUTO_MIGRATE" ]]; then
            bench migrate --skip-search-index
          fi

          if [[ "$DEVELOPER_MODE" = "1" ]]; then
            bench build
          fi

          bench start
          EOF
        ]
        env = local.env

        resources = var.resources

        volume_mounts = [
          {
            name       = "sites"
            mount_path = "/home/frappe/frappe-bench"
          },
        ],
      },
    ]

    init_containers = [
      {
        name  = "chown"
        image = var.image
        command = [
          "bash",
          "-cx",
          <<-EOF
            chown frappe:frappe /home/frappe/frappe-bench
          EOF
        ]
        env = local.env

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "sites"
            mount_path = "/home/frappe/frappe-bench"
          },
        ]
      },
      {
        name  = "init"
        image = var.image
        command = [
          "bash",
          "-cx",
          <<-EOF
          cd ~
          FORCE=$([ ! -f frappe-bench/Procfile ] && echo "--ignore-exist")
          if [[ ! -z "$FORCE" ]]; then
            bench init frappe-bench --skip-redis-config-generation $FORCE
            bench get-app $GET_APPS
          fi
          EOF
        ]
        env = local.env


        volume_mounts = [
          {
            name       = "sites"
            mount_path = "/home/frappe/frappe-bench"
          },
        ]
      },
    ]

    volumes = [
      {
        name = "sites"
        persistent_volume_claim = {
          claim_name = var.pvc_sites
        }
      },
    ]
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}