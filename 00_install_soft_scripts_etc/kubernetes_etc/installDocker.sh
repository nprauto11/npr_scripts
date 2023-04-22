#!/bin/bash

install_ubuntu() {
    ## Remove any pre installed docker packages:
    which docker
    if [ $? -eq 0 ];then
        systemctl stop docker.socket
        systemctl stop docker.service
        apt-get remove -y docker-ce docker-engine docker.io containerd runc
        apt-get purge -y docker-ce docker-ce-cli containerd.io
        apt -y autoremove
       cd /var/lib
       rm -rf docker
    else
       echo "docker is not installed.. continue to install"
    fi

    ## Install using the repository:
     apt-get update
     apt-get install -y apt-transport-https ca-certificates curl gnupg software-properties-common lsb-release
    ## Add Dockers official GPG key & stable repo
     mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg |  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list
    #curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -
    # add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    ## Install Docker latest
     apt-get update ; clear
     apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    if [ $? -eq 0 ];then
       if [ -f /etc/docker/daemon.json ];then
         echo "cgroup config is already configured skipping.."
       else
          echo "docker-ce is successfully installed"
          yum install -y wget
           wget https://raw.githubusercontent.com/lerndevops/labs/master/kubernetes/0-install/daemon.json -P /etc/docker
           service docker restart ; clear
       fi
    else
      echo "issue with docker-ce installation - process abort"
      exit 1
    fi
    exit 0
}

install_centos() {

    which docker
    if [ $? -eq 0 ];then
        yum remove docker-client-latest docker-latest docker-latest-logrotate docker-logrotate docker-engine
       cd /var/lib
       rm -rf docker
       yum clean
    else
       echo "docker is not installed... continue to install"
    fi

     yum install -y yum-utils   ## device-mapper-persistent-data lvm2
     yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
     yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    if [ $? -eq 0 ];then
       if [ -f /etc/docker/daemon.json ];then
         echo "cgroup config is already configured skipping.."
       else
          echo "docker-ce is successfully installed"
          yum install -y wget
           wget https://raw.githubusercontent.com/lerndevops/labs/master/kubernetes/0-install/daemon.json -P /etc/docker
           service docker restart ; clear
       fi
    else
      echo "issue with docker-ce installation - process abort"
      exit 1
    fi
}
################ MAIN ###################

if [ -f /etc/os-release ];then
   osname=`grep ID /etc/os-release | egrep -v 'VERSION|LIKE|VARIANT|PLATFORM' | cut -d'=' -f2 | sed -e 's/"//' -e 's/"//'`
   echo $osname
   if [ $osname == "ubuntu" ];then
       install_ubuntu
   elif [ $osname == "amzn" ];then
       install_centos
   elif [ $osname == "centos" ];then
       install_centos
  fi
else
   echo "can not locate /etc/os-release - unable find the osname"
   exit 8
fi
exit 0
