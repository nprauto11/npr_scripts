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

