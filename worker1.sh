#!/bin/bash
#=============================================================================================
#                                            workers
#=============================================================================================

# Set the required version (update as needed)
INSTALL_RKE2_VERSION="v1.25.0+rke2r1"  # Update to the desired version (e.g., v1.25.0+rke2r1)
NODE_NAME="rke2-worker"
CNI="calico"
TLS_SAN1="private ip of master node"  # Replace with the private IP of the master node

# Set up the RKE2 worker node configuration
export INSTALL_RKE2_TYPE="agent"
mkdir -p /etc/rancher/rke2/

# Set the token from the master node and other configurations
cat <<EOF >/etc/rancher/rke2/config.yaml
token: $TOKEN
server: https://$TLS_SAN1:9345
node-name: $NODE_NAME
cni: $CNI
EOF

# Install the specified version of RKE2 agent
curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION="$INSTALL_RKE2_VERSION" INSTALL_RKE2_TYPE="$INSTALL_RKE2_TYPE" sh -

# Enable and start the RKE2 agent service
systemctl enable rke2-agent.service
systemctl start rke2-agent.service

# Get the worker node's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Print success message
echo "RKE2 installation completed successfully!"
echo "Server IP: $SERVER_IP"
echo "hostname: $(hostname)"
