microk8s status --wait-ready
microk8s add-node

microk8s enable dns storage

microk8s stop
microk8s start