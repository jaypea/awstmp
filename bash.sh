#!/bin/bash
set -e
PROXY="http://proxy.acme.aws:3128"
NOPROXY="169.254.169.254,ssm.eu-west-1.amazonaws.com,ec2.eu-west-1.amazonaws.com,ec2messages.eu-west-1.amazonaws.com"
mkdir -p /etc/systemd/system/snap.amazon-ssm-agent.amazon-ssm-agent.service.d
cat << EOF > /etc/systemd/system/snap.amazon-ssm-agent.amazon-ssm-agent.service.d/override.conf
[Service]
Environment="http_proxy=$PROXY"  
Environment="https_proxy=$PROXY"
Environment="no_proxy=$NOPROXY"
EOF
systemctl daemon-reload
systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent.service
cat << EOF > /etc/apt/apt.conf.d/02proxy
Acquire {
HTTP::proxy "$PROXY";
HTTPS::proxy "$PROXY";
}
EOF
echo "Proxy configuration complete."
