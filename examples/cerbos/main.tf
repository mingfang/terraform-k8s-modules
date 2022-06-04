resource "k8s_core_v1_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "cerbos" {
  length  = 32
  special = false
}

module "postgres-config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  from-map = {
    "cerbos.sql" = <<-EOF
    CREATE SCHEMA IF NOT EXISTS cerbos;

    SET search_path TO cerbos;

    CREATE TABLE IF NOT EXISTS policy (
        id bigint NOT NULL PRIMARY KEY,
        kind VARCHAR(128) NOT NULL,
        name VARCHAR(1024) NOT NULL,
        version VARCHAR(128) NOT NULL,
        scope VARCHAR(512),
        description TEXT,
        disabled BOOLEAN default false,
        definition BYTEA
    );

    CREATE TABLE IF NOT EXISTS policy_dependency (
        policy_id BIGINT,
        dependency_id BIGINT,
        PRIMARY KEY (policy_id, dependency_id),
        FOREIGN KEY (policy_id) REFERENCES cerbos.policy(id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS policy_ancestor (
        policy_id BIGINT,
        ancestor_id BIGINT,
        PRIMARY KEY (policy_id, ancestor_id),
        FOREIGN KEY (policy_id) REFERENCES cerbos.policy(id) ON DELETE CASCADE
    );

    CREATE TABLE IF NOT EXISTS policy_revision (
        revision_id SERIAL PRIMARY KEY,
        action VARCHAR(64),
        id BIGINT,
        kind VARCHAR(128),
        name VARCHAR(1024),
        version VARCHAR(128),
        scope VARCHAR(512),
        description TEXT,
        disabled BOOLEAN,
        definition BYTEA,
        update_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS attr_schema_defs (
        id VARCHAR(255) PRIMARY KEY,
        definition JSON
    );

    CREATE OR REPLACE FUNCTION process_policy_audit() RETURNS TRIGGER AS $policy_audit$
        BEGIN
            IF (TG_OP = 'DELETE') THEN
                INSERT INTO policy_revision(action, id, kind, name, version, scope, description, disabled, definition)
                VALUES('DELETE', OLD.id, OLD.kind, OLD.name, OLD.version, OLD.scope, OLD.description, OLD.disabled, OLD.definition);
            ELSIF (TG_OP = 'UPDATE') THEN
                INSERT INTO policy_revision(action, id, kind, name, version, scope, description, disabled, definition)
                VALUES('UPDATE', NEW.id, NEW.kind, NEW.name, NEW.version, NEW.scope, NEW.description, NEW.disabled, NEW.definition);
            ELSIF (TG_OP = 'INSERT') THEN
                INSERT INTO policy_revision(action, id, kind, name, version, scope, description, disabled, definition)
                VALUES('INSERT', NEW.id, NEW.kind, NEW.name, NEW.version, NEW.scope, NEW.description, NEW.disabled, NEW.definition);
            END IF;
            RETURN NULL;
        END;
    $policy_audit$ LANGUAGE plpgsql;

    CREATE TRIGGER policy_audit
    AFTER INSERT OR UPDATE OR DELETE ON policy
    FOR EACH ROW EXECUTE PROCEDURE process_policy_audit();

    CREATE USER cerbos_user WITH PASSWORD '${random_password.cerbos.result}';
    GRANT CONNECT ON DATABASE postgres TO cerbos_user;
    GRANT USAGE ON SCHEMA cerbos TO cerbos_user;
    GRANT SELECT,INSERT,UPDATE,DELETE ON cerbos.policy, cerbos.policy_dependency, cerbos.policy_ancestor, cerbos.attr_schema_defs TO cerbos_user;
    GRANT SELECT,INSERT ON cerbos.policy_revision TO cerbos_user;
    GRANT USAGE,SELECT ON cerbos.policy_revision_revision_id_seq TO cerbos_user;
    EOF
  }
}

module "postgres" {
  source    = "../../modules/postgres"
  name      = "postgres"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  storage_class = "cephfs"
  storage       = "1Gi"

  configmap = module.postgres-config.config_map

  POSTGRES_USER     = "postgres"
  POSTGRES_PASSWORD = "postgres"
}

module "config" {
  source    = "../../modules/kubernetes/config-map"
  name      = "cerbos"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  #        passwordHash: ${base64encode(bcrypt("cerbos_admin"))}

  from-map = {
    "config.yaml" = <<-EOF
    server:
      adminAPI:
        enabled: true
        adminCredentials:
          username: cerbos_admin
          passwordHash: JDJ5JDEwJE5HYnk4cTY3VTE1bFV1NlR2bmp3ME9QOXdXQXFROGtBb2lWREdEY2xXbzR6WnoxYWtSNWNDCgo=
    storage:
      driver: "postgres"
      postgres:
        url: "postgres://cerbos_user:${random_password.cerbos.result}@${module.postgres.name}:${module.postgres.ports[0].port}/postgres?sslmode=disable&search_path=cerbos"
    EOF
  }
}

module "cerbos" {
  source    = "../../modules/cerbos"
  name      = "cerbos"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
  replicas  = 1

  args = [
    "server",
    "--config=/config/cerbos/config.yaml",
  ]

  configmap = module.config.config_map
}

resource "k8s_networking_k8s_io_v1beta1_ingress" "cerbos" {
  metadata {
    annotations = {
      "kubernetes.io/ingress.class"              = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "${var.namespace}.*"
    }
    name      = module.cerbos.name
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }
  spec {
    rules {
      host = var.namespace
      http {
        paths {
          backend {
            service_name = module.cerbos.name
            service_port = module.cerbos.ports[0].port
          }
          path = "/"
        }
      }
    }
  }
}
