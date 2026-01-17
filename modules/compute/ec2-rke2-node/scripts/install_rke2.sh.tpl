#!/bin/bash
export INSTALL_RKE2_VERSION="${rke2_version}"
export INSTALL_RKE2_TYPE="${rke2_role}"

curl -sfL https://get.rke2.io | sh -

mkdir -p /etc/rancher/rke2/
echo "token: ${rke2_token}" > /etc/rancher/rke2/config.yaml

if [ "${rke2_role}" == "server" ]; then
  systemctl enable rke2-server.service
  systemctl start rke2-server.service
else
  # For agent, we would need the server URL as well, but this is a simplified example template
  systemctl enable rke2-agent.service
  systemctl start rke2-agent.service
fi
