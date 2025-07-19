#!/usr/bin/env bash

echo ">>>> K8S Node config Start <<<<"

echo "[TASK 1] K8S Controlplane Join"
sed -i "s/IP_PLACEHOLDER/192.168.10.10$1/g" /tmp/join-cfg.yaml
sed -i "s/NODENAME_PLACEHOLDER/k8s-w$1/g" /tmp/join-cfg.yaml
kubeadm join --config /tmp/join-cfg.yaml
#kubeadm join --config /vagrant/join-w$1.yaml
#kubeadm join --token 123456.1234567890123456 --discovery-token-unsafe-skip-ca-verification 192.168.10.100:6443  >/dev/null 2>&1


echo ">>>> K8S Node config End <<<<"