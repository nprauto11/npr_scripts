#!/bin/bash

mkdir -p /tmp/utilities
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/aws_userdata_common/aws_ubuntu22_install-all_01.sh /tmp/utilities
bash /tmp/utilities/aws_ubuntu22_install-all_01.sh


echo " " >> /tmp/utilities/status
echo "########### kubernet cluster installation etc " >> /tmp/utilities/status
echo "kubernetes basic tools installation started at $(date)" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installDocker.sh /tmp/utilities
bash /tmp/utilities/installDocker.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed Docker" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installCRIDockerd.sh /tmp/utilities
bash /tmp/utilities/installDocker.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed CRI-Dockerd (adapter to control Docker via the Kubernetes Container Runtime Interface" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status


wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installK8S.sh /tmp/utilities
bash /tmp/utilities/installK8S.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed K8s -- kubeadm, kubelet, kubectl" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "kubernetes basic tools installation done on $(date)" >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "$ docker -v " >> /tmp/utilities/status
docker -v >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "$ cri-dockerd --version " >> /tmp/utilities/status
cri-dockerd --version >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "$ kubeadm version -o short " >> /tmp/utilities/status
kubeadm version -o short >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
   
echo "$ kubelet --version " >> /tmp/utilities/status
kubelet --version >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
   
echo "$ kubectl version --short --client" >> /tmp/utilities/status
kubectl version --short --client >> /tmp/utilities/status
echo " " >> /tmp/utilities/status   
echo " " >> /tmp/utilities/status


echo "########### execute manually on Master Node like below: " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm_init_master.sh /tmp/utilities

echo "$ sudo bash /tmp/utilities/kubeadm_init_master.sh " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "To verify node status hit below command. wait for sometime to get ready:" >> /tmp/utilities/status
echo "$ kubectl get nodes" >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
echo "Run Below to get join token for adding node to cluster:" >> /tmp/utilities/status
echo "$ kubeadm token create --print-join-command "  >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "NOTE:- copy the kubeadm join token from master & ensure to add --cri-socket unix:///var/run/cri-dockerd.sock as below & then run on worker nodes"  >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "EXAMPLE:- run on nodes like below with adding dockerd sock on above command output:" >> /tmp/utilities/status
echo "$ kubeadm join 172.31.7.65:6443 --cri-socket unix:///var/run/cri-dockerd.sock --token 3p8bzg.sulks92b5xvrdwm4 --discovery-token-ca-cert-hash sha256:9de17e4f40a3d248ddaea0c67c73ae2bf0c0ee36e6f106592c83536e680b71f1 " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "enjoy with kubernetes cluster! " >> /tmp/utilities/status

