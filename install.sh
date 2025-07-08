#!/bin/bash

curl -sL https://raw.githubusercontent.com/DimaVIII/CentOS-repo/main/install.sh | sh

yum install yum-utils -y

yum-config-manager --add-repo https://pkgs.tailscale.com/stable/centos/7/tailscale.repo -y

yum install tailscale -y

systemctl enable --now tailscaled


# IP Forwarding
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

firewall-cmd --permanent --add-masquerade
firewall-cmd --reload


# Set network
tailscale set --advertise-routes=192.0.10.0/24
tailscale set --exit-node-allow-lan-access


# Enable Exit node
tailscale set --advertise-exit-node


tailscale up
