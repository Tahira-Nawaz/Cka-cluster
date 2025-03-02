#=============================================================================================
#                                            master                           
#=============================================================================================
#!/bin/bash
NODE_NAME="rke2-master"
CNI_PLUGIN="calico"
RKE2_URL="https://get.rke2.io"
INSTALL_RKE2_TYPE="server"
export INSTALL_RKE2_VERSION="v1.24.10+rke2r1"
sudo hostnamectl set-hostname rke2-master
mkdir -p /etc/rancher/rke2/

cat <<EOF >/etc/rancher/rke2/config.yaml
cni: $CNI_PLUGIN
node-taint:
  - "CriticalAddonsOnly=true:NoExecute"
EOF

# Install RKE2
curl -sfL $RKE2_URL | INSTALL_RKE2_TYPE="$INSTALL_RKE2_TYPE" INSTALL_RKE2_VERSION="$INSTALL_RKE2_VERSION" sh -
systemctl enable rke2-server.service
systemctl start rke2-server.service

# Configure kubectl
sudo mkdir ~/.kube
sudo cp /var/lib/rancher/rke2/bin/kubectl /usr/local/bin
sudo cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
sudo chmod 644 ~/.kube/config

# Configure kubectl for local
sudo cp /etc/rancher/rke2/rke2.yaml /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
sudo chmod 644 /home/ubuntu/.kube/config


# Get the server's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Get the RKE2 token
RKE2_TOKEN=$(cat /var/lib/rancher/rke2/server/token)

# Print success message
echo "RKE2 installation completed successfully!"
echo "Server IP: $SERVER_IP"
echo "RKE2 Token: $RKE2_TOKEN"