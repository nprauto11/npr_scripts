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
bash /tmp/utilities/aws_ubuntu22_install-all_01.sh

# kubeadm cluster tools installtion
# Bettter launch t2.medium/t3.medium ec2-instances  i.e 1-master, 2-nodes
mkdir -p /tmp/utilities
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/aws_ubuntu22_kubeadm_tools_install.sh -P /tmp/utilities
chmod 755 /tmp/utilities/aws_ubuntu22_kubeadm_tools_install.sh
bash /tmp/utilities/aws_ubuntu22_kubeadm_tools_install.sh



echo "########### Step-1: RUN manually on Master Node with below steps:- ###########" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo 'change the hostname of the master-node:' >> /tmp/utilities/status
echo '$ hostname master' >> /tmp/utilities/status
echo '$ echo "master" > /etc/hostname' >> /tmp/utilities/status    
echo '$ echo "127.0.1.1    master" >> /etc/hosts' >> /tmp/utilities/status
echo 'Re-connect sesion (putty) for hostname reflection' >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm_init_master.sh -P /tmp/utilities
chmod 755 /tmp/utilities/kubeadm_init_master.sh

echo "Execute below command to initialise kubeadm in Master-Node: " >> /tmp/utilities/status
echo "$ sudo bash /tmp/utilities/kubeadm_init_master.sh " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "To verify node status hit below command. wait for sometime to get ready:" >> /tmp/utilities/status
echo "$ kubectl get nodes" >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
echo "Run Below command to get join token for adding node to cluster:" >> /tmp/utilities/status
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
echo " " >> /tmp/utilities/status

echo "########### Step-2: RUN manually on worker-1 node with below steps:- ###########" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo 'change the hostname of the worker-1 node:' >> /tmp/utilities/status
echo '$ hostname worker-1' >> /tmp/utilities/status
echo '$ echo "worker-1" > /etc/hostname' >> /tmp/utilities/status    
echo '$ echo "127.0.1.1    worker-1" >> /etc/hosts' >> /tmp/utilities/status
echo 'Re-connect sesion (putty) for hostname reflection' >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
echo "How to join node to Cluster:" >> /tmp/utilities/status
echo "Run token get from Master node with adding --cri-socket unix:///var/run/cri-dockerd.sock" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "Ex:- "  >> /tmp/utilities/status
echo "$ kubeadm join 172.31.7.65:6443 --token 3p8bzg.sulks92b5xvrdwm4 --discovery-token-ca-cert-hash sha256:9de17e4f40a3d248ddaea0c67c73ae2bf0c0ee36e6f106592c83536e680b71f1 --cri-socket unix:///var/run/cri-dockerd.sock "  >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "########### Step-3: RUN manually on worker-2 node with below steps:- ###########" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo 'change the hostname of the worker-2 node:' >> /tmp/utilities/status
echo '$ hostname worker-2' >> /tmp/utilities/status
echo '$ echo "worker-2" > /etc/hostname' >> /tmp/utilities/status    
echo '$ echo "127.0.1.1    worker-2" >> /etc/hosts' >> /tmp/utilities/status
echo 'Re-connect sesion (putty) for hostname reflection' >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
echo "How to join node to Cluster:" >> /tmp/utilities/status
echo "Run token get from Master node with adding --cri-socket unix:///var/run/cri-dockerd.sock" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "Ex:- "  >> /tmp/utilities/status
echo "$ kubeadm join 172.31.7.65:6443 --token 3p8bzg.sulks92b5xvrdwm4 --discovery-token-ca-cert-hash sha256:9de17e4f40a3d248ddaea0c67c73ae2bf0c0ee36e6f106592c83536e680b71f1 --cri-socket unix:///var/run/cri-dockerd.sock "  >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

echo "============================================= " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "For kubeadm cluster configuration, go through step-1 (or) step-2:- " >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "Step-1 --> browse the below link & execute the commands: " >> /tmp/utilities/status
echo "Link:- https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm-cluster-install-configure_steps.txt " >> /tmp/utilities/status

wget https://raw.githubusercontent.com/nprauto11/npr_scripts/main/00_install_soft_scripts_etc/kubernetes_etc/kubeadm-cluster-install-configure_steps.txt -P /tmp/utilities
echo " " >> /tmp/utilities/status
echo "Step-2 --> read the steps file & execute the commands: " >> /tmp/utilities/status
echo " cat /tmp/utilities/kubeadm-cluster-install-configure_steps.txt" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status
echo "########################################## " >> /tmp/utilities/status