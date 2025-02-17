#!/bin/bash
#=============================================================================================
#                                            master
#=============================================================================================

# Set the required version (replace with your desired version)
INSTALL_RKE2_VERSION="v1.25.0+rke2r1"  # Update to your desired version
NODE_NAME="rke2-master"
CNI_PLUGIN="calico"
RKE2_URL="https://get.rke2.io"
INSTALL_RKE2_TYPE="server"

# Set the hostname of the master node
sudo hostnamectl set-hostname $NODE_NAME

# Create the directory for RKE2 configuration
mkdir -p /etc/rancher/rke2/

# Configure the RKE2 server settings (you can customize further as needed)
cat <<EOF >/etc/rancher/rke2/config.yaml
cni: $CNI_PLUGIN
node-taint:
  - "CriticalAddonsOnly=true:NoExecute"
EOF

# Install the specified version of RKE2
curl -sfL $RKE2_URL | INSTALL_RKE2_TYPE="$INSTALL_RKE2_TYPE" INSTALL_RKE2_VERSION="$INSTALL_RKE2_VERSION" sh -

# Enable and start the RKE2 server service
systemctl enable rke2-server.service
systemctl start rke2-server.service

# Configure kubectl for the master node
sudo mkdir -p ~/.kube
sudo cp /var/lib/rancher/rke2/bin/kubectl /usr/local/bin
sudo cp /etc/rancher/rke2/rke2.yaml ~/.kube/config
sudo chmod 644 ~/.kube/config

# Configure kubectl for the local user (if required, specify the user)
sudo cp /etc/rancher/rke2/rke2.yaml /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
sudo chmod 644 /home/ubuntu/.kube/config

# Get the server's IP address (you can update this if necessary)
SERVER_IP=$(hostname -I | awk '{print $1}')

# Get the RKE2 token (you will use this for worker node registration)
RKE2_TOKEN=$(cat /var/lib/rancher/rke2/server/token)

# Print success message
echo "RKE2 installation completed successfully!"
echo "Server IP: $SERVER_IP"
echo "RKE2 Token: $RKE2_TOKEN"
