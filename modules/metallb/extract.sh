#!/usr/bin/env bash

function tfextract() {
    go run cmd/extractor/*go $@
}

export DIR=modules/metallb

tfextract -dir ${DIR} -url https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml

rm ${DIR}/*namespace.tf

sed -i -e 's|namespace *= "metallb-system"|namespace = k8s_core_v1_service_account.speaker.metadata.0.namespace|g' ${DIR}/metallb-system_speaker-cluster_role_binding.tf
sed -i -e 's|namespace *= "metallb-system"|namespace = var.namespace|g' ${DIR}/*tf
#remove namespace in speaker-pod_security_policy.tf

terraform fmt ${DIR}