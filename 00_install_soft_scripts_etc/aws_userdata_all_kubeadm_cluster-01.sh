#!/bin/bash

##################################################################################################
# Scrit_Name: aws_userdata_all_kubeadm_cluster-01.sh                                             # 
# Maintainer: nprauto11                                                                          #
# Description: installing on ubuntu 22.04-->  jenkins, tomcat, nginx, maven, awscli, docker-cli, #
#              docker-compose, terraform                                                         #
#              and kubeadm cluster (docker engine,cri-dockerd, kubeadm, kubelet, kubectl         #
#              ** This is verymuch useful script for AWS ec2 userdata option on AWS ec2 spin-up  #         
# version: v1                                                                                    #  
# Log: /tmp/utilities/status                                                                     #
##################################################################################################


#Software installations: nginx,ansible,terraform, docker, docker-compose,tomcat,jenkins
mkdir -p /tmp/utilities
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/aws_userdata_common/aws_ubuntu22_install-all_01.sh -P /tmp/utilities
chmod 755 /tmp/utilities/aws_ubuntu22_install-all_01.sh
sh /tmp/utilities/aws_ubuntu22_install-all_01.sh


echo " " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "########### kubernet cluster installation etc ###########" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "kubernetes basic tools installation started at $(date)" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

# kubeadm cluster (Bettter launch t2.medium/t3.medium of 3 nodes i.e 1-master, 2-nodes)
#Software installation: Dokcker
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installDocker.sh -P /tmp/utilities
chmod 755 /tmp/utilities/installDocker.sh
sh /tmp/utilities/installDocker.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed Docker" >> /tmp/utilities/status

#Software installation: CRI-Dockerd
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installCRIDockerd.sh -P /tmp/utilities
chmod 755 /tmp/utilities/installCRIDockerd.sh
sh /tmp/utilities/installCRIDockerd.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed CRI-Dockerd (adapter to control Docker via the Kubernetes Container Runtime Interface)" >> /tmp/utilities/status


#Software installations: kubeadm, kubelet, kubectl
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installK8S.sh -P /tmp/utilities
chmod 755 /tmp/utilities/installK8S.sh
sh /tmp/utilities/installK8S.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed K8s -- kubeadm, kubelet, kubectl" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "## kubernetes basic tools installation done on $(date) ##" >> /tmp/utilities/status

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


echo "########### RUN manually on Master Node with below steps:- ###########" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm_init_master.sh -P /tmp/utilities
chmod 755 /tmp/utilities/kubeadm_init_master.sh

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
echo " " >> /tmp/utilities/status
echo "########################################## " >> /tmp/utilities/status


