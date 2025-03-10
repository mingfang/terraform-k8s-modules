#!/usr/bin/env bash

function tfextract() {
    go run /go/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor/*go $@
}

export DIR=.
mkdir -p ${DIR}

tfextract -dir ${DIR} -url https://github.com/ceph/ceph-csi/raw/devel/deploy/cephfs/kubernetes/csi-cephfsplugin-provisioner.yaml
tfextract -dir ${DIR} -url https://github.com/ceph/ceph-csi/raw/devel/deploy/cephfs/kubernetes/csi-cephfsplugin.yaml
tfextract -dir ${DIR} -url https://github.com/ceph/ceph-csi/raw/devel/deploy/cephfs/kubernetes/csi-config-map.yaml
tfextract -dir ${DIR} -url https://github.com/ceph/ceph-csi/raw/devel/deploy/cephfs/kubernetes/csi-nodeplugin-rbac.yaml
tfextract -dir ${DIR} -url https://github.com/ceph/ceph-csi/raw/devel/deploy/cephfs/kubernetes/csi-provisioner-rbac.yaml
tfextract -dir ${DIR} -url https://github.com/ceph/ceph-csi/raw/devel/deploy/cephfs/kubernetes/csidriver.yaml
tfextract -dir ${DIR} -url https://github.com/ceph/ceph-csi/raw/devel/deploy/ceph-conf.yaml

sed -i -e 's|namespace *= "default"|namespace = k8s_core_v1_namespace.this.metadata[0].name|g' *.tf

#fmt
terraform fmt ${DIR}

# ceph_csi_encryption_kms_config-config_map.tf were manually created
# manually add "namespace = k8s_core_v1_namespace.this.metadata[0].name"