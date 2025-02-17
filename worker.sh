########                             workers                           #######################
##############################################################################################

#!/bin/bash

TOKEN="token from the master node"
NODE_NAME="rke2-worker"
CNI="calico"
TLS_SAN1="private ip of master node "
export INSTALL_RKE2_VERSION="v1.24.10+rke2r1"
INSTALL_RKE2_TYPE="agent"
mkdir -p /etc/rancher/rke2/
cat <<EOF >/etc/rancher/rke2/config.yaml
token: $TOKEN
server: https://$TLS_SAN1:9345
node-name: $NODE_NAME
cni: $CNI
EOF

curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION="$INSTALL_RKE2_VERSION" INSTALL_RKE2_TYPE="$INSTALL_RKE2_TYPE" sh -
systemctl enable rke2-agent.service
systemctl start rke2-agent.service