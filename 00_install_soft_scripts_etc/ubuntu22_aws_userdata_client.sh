#!/bin/bash
user1=ubuntu
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx 

mkdir -p /tmp/utilities/softwares 
git clone https://github.com/nprauto11/npr_scripts.git /tmp/utilities/softwares
cd /tmp/utilities/softwares/00_install_soft_scripts_etc
sh indexpage_nginx_ubuntu22.sh

mkdir -p /tmp/utilities/keys
git clone https://github.com/nprauto11/npr_ansible_practice.git /tmp/utilities/keys
cd /tmp/utilities/keys/00_ssh_keys
cat id_rsa.pub >> ~/.ssh/authorized_keys

cd /tmp && chown -R $user1 utilities
su - $user1
cd /tmp/utilities/keys/00_ssh_keys
cat id_rsa.pub >> ~/.ssh/authorized_keys

