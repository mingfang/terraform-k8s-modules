/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  labels = {
    app     = var.name
    name    = var.name
    service = var.name
  }

  parameters = {
    name                 = var.name
    namespace            = var.namespace
    labels               = local.labels
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "etcd"
        image = var.image
        env = [
          {
            name = "CLUSTER_NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
          {
            name  = "INITIAL_CLUSTER_SIZE"
            value = var.replicas
          },
          {
            name  = "SET_NAME"
            value = var.name
          },
        ]

        command = [
          "/bin/sh",
          "-ec",
          <<-EOF
          HOSTNAME=$(hostname)
          # store member id into PVC for later member replacement
          collect_member() {
              while ! etcdctl member list &>/dev/null; do sleep 1; done
              etcdctl member list | grep http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2380 | cut -d':' -f1 | cut -d'[' -f1 > /var/run/etcd/member_id
              exit 0
          }
          eps() {
              EPS=""
              for i in $(seq 0 $(($${INITIAL_CLUSTER_SIZE} - 1))); do
                  EPS="$${EPS}$${EPS:+,}http://$${SET_NAME}-$${i}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2379"
              done
              echo $${EPS}
          }
          member_hash() {
              etcdctl member list | grep http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2380 | cut -d':' -f1 | cut -d'[' -f1
          }
            # we should wait for other pods to be up before trying to join
            # otherwise we got "no such host" errors when trying to resolve other members
            for i in $(seq 0 $(($${INITIAL_CLUSTER_SIZE} - 1))); do
                while true; do
                    echo "Waiting for $${SET_NAME}-$${i}.$${SET_NAME}.$${CLUSTER_NAMESPACE} to come up"
                    ping -W 1 -c 1 $${SET_NAME}-$${i}.$${SET_NAME}.$${CLUSTER_NAMESPACE} > /dev/null && break
                    sleep 1s
                done
            done
          # re-joining after failure?
          if [ -e /var/run/etcd/member_id ]; then
              echo "Re-joining etcd member"
              member_id=$(cat /var/run/etcd/member_id)
              # re-join member
              ETCDCTL_ENDPOINT=$(eps) etcdctl member update $${member_id} http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2380 | true
              exec etcd --name $${HOSTNAME} \
                  --listen-peer-urls http://0.0.0.0:2380 \
                  --listen-client-urls http://0.0.0.0:2379 \
                  --advertise-client-urls http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2379 \
                  --data-dir /var/run/etcd/default.etcd
          fi
          # etcd-SET_ID
            SET_ID=$${HOSTNAME##*[^0-9]}
          # adding a new member to existing cluster (assuming all initial pods are available)
          if [ "$${SET_ID}" -ge $${INITIAL_CLUSTER_SIZE} ]; then
              export ETCDCTL_ENDPOINT=$(eps)
              # member already added?
              MEMBER_HASH=$(member_hash)
              if [ -n "$${MEMBER_HASH}" ]; then
                  # the member hash exists but for some reason etcd failed
                  # as the datadir has not be created, we can remove the member
                  # and retrieve new hash
                  etcdctl member remove $${MEMBER_HASH}
              fi
              echo "Adding new member"
              etcdctl member add $${HOSTNAME} http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2380 | grep "^ETCD_" > /var/run/etcd/new_member_envs
              if [ $? -ne 0 ]; then
                  echo "Exiting"
                  rm -f /var/run/etcd/new_member_envs
                  exit 1
              fi
              cat /var/run/etcd/new_member_envs
              source /var/run/etcd/new_member_envs
              collect_member &
              exec etcd --name $${HOSTNAME} \
                  --listen-peer-urls http://0.0.0.0:2380 \
                  --listen-client-urls http://0.0.0.0:2379 \
                  --advertise-client-urls http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2379 \
                  --data-dir /var/run/etcd/default.etcd \
                  --initial-advertise-peer-urls http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2380 \
                  --initial-cluster $${ETCD_INITIAL_CLUSTER} \
                  --initial-cluster-state $${ETCD_INITIAL_CLUSTER_STATE}
          fi
          PEERS=""
          for i in $(seq 0 $(($${INITIAL_CLUSTER_SIZE} - 1))); do
              PEERS="$${PEERS}$${PEERS:+,}$${SET_NAME}-$${i}=http://$${SET_NAME}-$${i}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2380"
          done
          collect_member &
          # join member
          exec etcd --name $${HOSTNAME} \
              --initial-advertise-peer-urls http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2380 \
              --listen-peer-urls http://0.0.0.0:2380 \
              --listen-client-urls http://0.0.0.0:2379 \
              --advertise-client-urls http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2379 \
              --initial-cluster-token etcd-cluster-1 \
              --initial-cluster $${PEERS} \
              --initial-cluster-state new \
              --data-dir /var/run/etcd/default.etcd
          EOF
        ]

        lifecycle = {
          pre_stop = {
            exec = {
              command = [
                "/bin/sh",
                "-ec",
                <<-EOF
                EPS=""
                for i in $(seq 0 $(($${INITIAL_CLUSTER_SIZE} - 1))); do
                    EPS="$${EPS}$${EPS:+,}http://$${SET_NAME}-$${i}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2379"
                done
                HOSTNAME=$(hostname)
                member_hash() {
                    etcdctl member list | grep http://$${HOSTNAME}.$${SET_NAME}.$${CLUSTER_NAMESPACE}:2380 | cut -d':' -f1 | cut -d'[' -f1
                }
                echo "Removing $${HOSTNAME} from etcd cluster"
                ETCDCTL_ENDPOINT=$${EPS} etcdctl member remove $(member_hash)
                if [ $? -eq 0 ]; then
                    # Remove everything otherwise the cluster will no longer scale-up
                    rm -rf /var/run/etcd/*
                fi
                EOF
              ]
            }
          }
        }

        liveness_probe = {
          initial_delay_seconds = 60

          exec = {
            command = [
              "sh",
              "-cx",
              "ETCDCTL_API=3 /usr/local/bin/etcdctl endpoint health",
            ]
          }
        }

        resources = {
          requests = {
            cpu    = "100m"
            memory = "512Mi"
          }
        }

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/var/run/etcd"
            sub_path   = var.name
          }
        ]
      },
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
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}