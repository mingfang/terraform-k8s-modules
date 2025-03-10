#!/usr/bin/env bash

function tfextract() {
    go run cmd/extractor/*go $@
}

export DIR=modules/kubernetes/csi

# nodeplugin

mkdir -p ${DIR}/nodeplugin

tfextract -dir ${DIR}/nodeplugin -url https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/kubernetes/csi-nodeplugin-nfsplugin.yaml
tfextract -dir ${DIR}/nodeplugin -url https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/kubernetes/csi-nodeplugin-rbac.yaml

#sed -i -e '3 a namespace = var.namespace' ${DIR}/nodeplugin/*{service_account,daemon_set}.tf
sed -i -e 's|namespace *=.*|namespace = var.namespace|g' ${DIR}/nodeplugin/*.tf
sed -i -e 's|= "csi-nodeplugin.*"|= var.name|g' ${DIR}/nodeplugin/*.tf
sed -i -e 's|/csi-nfsplugin|/${var.name}|g' ${DIR}/nodeplugin/*.tf
sed -i -e 's|"nfs"|var.name|g' ${DIR}/nodeplugin/*.tf
sed -i -e 's|csi-nodeplugin-nfsplugin|csi-nodeplugin|g' ${DIR}/nodeplugin/*.tf
sed -i -e 's|image = "quay.io/k8scsi/csi-node-driver-registrar:v1.0.2"|image = "quay.io/k8scsi/csi-node-driver-registrar:v1.1.0"|g' ${DIR}/nodeplugin/*.tf
sed -i -e 's|IfNotPresent|Always|g' ${DIR}/nodeplugin/*.tf
sed -i -e 's|image *= "quay.io/k8scsi/nfsplugin.*"|image = var.image\n command = var.command\n|g' ${DIR}/nodeplugin/*.tf
sed -i -e 's|host_network *= true||g' ${DIR}/nodeplugin/*.tf

# attacher and provisioner

for module in {attacher,provisioner}; do

mkdir -p ${DIR}/${module}

tfextract -dir ${DIR}/${module} -url https://raw.githubusercontent.com/kubernetes-csi/external-${module}/master/deploy/kubernetes/deployment.yaml
tfextract -dir ${DIR}/${module} -url https://raw.githubusercontent.com/kubernetes-csi/external-${module}/master/deploy/kubernetes/rbac.yaml

sed -i -e 's|namespace *=.*|namespace = var.namespace|g' ${DIR}/${module}/*.tf
sed -i -e 's|image *= ".*mock.*"|image = var.image\n args = var.args\n command = var.command\n env {\n name = "NODE_ID"\n value_from {\n field_ref {\n field_path = "spec.nodeName"\n }\n }\n }|g' ${DIR}/${module}/*.tf
sed -i -e 's|IfNotPresent|Always|g' ${DIR}/${module}/*.tf
sed -i -e "s|\"external-${module}\" = \"mock-driver\"|\"app\" = var.name|g" ${DIR}/${module}/*.tf
sed -i -e "s|= \"csi-${module}\"|= var.name|g" ${DIR}/${module}/*.tf
sed -i -e "s|= \"csi-${module}-|= \"\${var.name}-|g" ${DIR}/${module}/*.tf
sed -i -e "s|= \"external-${module}|= \"\${var.name}|g" ${DIR}/${module}/*.tf
sed -i -e 's|"mock-driver"|"${var.name}-driver"|g' ${DIR}/${module}/*.tf
sed -i -e 's|/var/lib/csi/sockets/pluginproxy/mock.socket|unix://var/lib/csi/sockets/pluginproxy/${var.name}|g' ${DIR}/${module}/*.tf
#sed -i -e 's|"--enable-leader-election",|"--enable-leader-election",\n "--leader-election-type=leases",|g' ${DIR}/${module}/*.tf
sed -i -e '3 a namespace = var.namespace' ${DIR}/${module}/*deployment.tf
sed -i -e '6 a namespace = var.namespace' ${DIR}/${module}/*service.tf

cat <<EOF > ${DIR}/${module}/variables.tf
variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {}

variable "command" {
  default = []
}

variable "args" {
  default = []
}
EOF
done

terraform fmt -recursive ${DIR}