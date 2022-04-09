#!/bin/sh

sudo apt -y update
sudo apt -y upgrade

# Other packages
sudo apt install -y net-tools

# microk8s setup
sudo snap install microk8s --classic --channel=1.21/stable
sudo usermod -a -G microk8s ubuntu
sudo chown -f -R ubuntu ~/.kube
newgrp microk8s
alias kubectl='microk8s kubectl'

# https://stackoverflow.com/questions/52619828/kubernetes-no-route-to-host
sudo iptables -D  INPUT -j REJECT --reject-with icmp-host-prohibited
sudo iptables -D  FORWARD -j REJECT --reject-with icmp-host-prohibited