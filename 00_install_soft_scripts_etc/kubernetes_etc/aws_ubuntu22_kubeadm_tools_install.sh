#!/bin/bash

####################################################################################################
# Scrit_Name: aws_ubuntu22_kubeadm_tools_install.sh                                                # 
# Maintainer: nprauto11                                                                            #
# Description: installing on ubuntu 22.04-->  docker engine,cri-dockerd, kubeadm, kubelet, kubectl #
# version: v1                                                                                      #  
# Log: /tmp/utilities/status                                                                       #
####################################################################################################

# kubeadm cluster tools  installtion(Bettter launch t2.medium/t3.medium of 3 nodes i.e 1-master, 2-nodes)
mkdir -p /tmp/utilities
echo " " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "########### kubernet cluster (kubeadm) tools installation etc ###########" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "kubernetes basic tools installation started at $(date)" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status


#Software installation: Dokcker
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installDocker.sh -P /tmp/utilities
chmod 755 /tmp/utilities/installDocker.sh
sh /tmp/utilities/installDocker.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed Docker" >> /tmp/utilities/status

#Software installation: CRI-Dockerd
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installCRIDockerd.sh -P /tmp/utilities
chmod 755 /tmp/utilities/installCRIDockerd.sh
bash /tmp/utilities/installCRIDockerd.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed CRI-Dockerd (adapter to control Docker via the Kubernetes Container Runtime Interface)" >> /tmp/utilities/status


#Software installations: kubeadm, kubelet, kubectl
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/installK8S.sh -P /tmp/utilities
chmod 755 /tmp/utilities/installK8S.sh
bash /tmp/utilities/installK8S.sh
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed K8s -- kubeadm, kubelet, kubectl" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "## kubernetes basic tools installation done on $(date) ##" >> /tmp/utilities/status

# validation
echo " " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "$ docker -v " >> /tmp/utilities/status
docker -v >> /tmp/utilities/status 2>&1
echo " " >> /tmp/utilities/status

echo "$ cri-dockerd --version " >> /tmp/utilities/status
cri-dockerd --version >> /tmp/utilities/status 2>&1
echo " " >> /tmp/utilities/status

echo "$ kubeadm version -o short " >> /tmp/utilities/status
kubeadm version -o short >> /tmp/utilities/status 2>&1
echo " " >> /tmp/utilities/status
   
echo "$ kubelet --version " >> /tmp/utilities/status
kubelet --version >> /tmp/utilities/status 2>&1
echo " " >> /tmp/utilities/status
  
echo "$ kubectl version --client" >> /tmp/utilities/status
kubectl version --client >> /tmp/utilities/status 2>&1
echo " " >> /tmp/utilities/status   
echo " " >> /tmp/utilities/status

echo "=============================" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

# download 
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm_init_master.sh -P /tmp/utilities
chmod 755 /tmp/utilities/kubeadm_init_master.sh
# bash /tmp/utilities/kubeadm_init_master.sh


# For further steps browse: Link:- https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm-cluster-install-configure_steps.txt 
# steps
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm-cluster-install-configure_steps.txt -P /tmp/utilities
chmod 644 /tmp/utilities/kubeadm-cluster-install-configure_steps.txt


echo "For kubeadm cluster configuration, go through step-A (or) step-B:- " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "Step-A --> browse the below link & execute from Step-1: " >> /tmp/utilities/status
echo "Link:- https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm-cluster-install-configure_steps.txt " >> /tmp/utilities/status


echo " " >> /tmp/utilities/status
echo "Step-B --> read the steps file & & execute from Step-1: " >> /tmp/utilities/status
echo " cat /tmp/utilities/kubeadm-cluster-install-configure_steps.txt" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "########################################## " >> /tmp/utilities/status
