#!/bin/bash
user1=ubuntu
mkdir -p /tmp/utilities
echo "software installations started on $(date)" > /tmp/utilities/status
echo " " >> /tmp/utilities/status

apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx 
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed nginx $ started service. Access via port 80" >> /tmp/utilities/status

#mkdir -p /tmp/utilities/softwares 
#git clone https://github.com/nprauto11/npr_scripts.git /tmp/utilities/softwares
#cd /tmp/utilities/softwares/00_install_soft_scripts_etc
#sh indexpage_nginx_ubuntu22.sh

cd /tmp/utilities
file=index.html
echo "<html><head><title>index</title></head><body>" > $file 
echo "&nbsp" >> $file
echo "<h1> Hi! welcome everyone!</h1>" >> $file
echo "<h2>below are host (client) Details:-</h2>" >> $file
echo "<p>public_ip-adress: $(curl ifconfig.me)" >> $file
echo "&nbsp </p>" >> $file
echo "local_ip-address: `hostname -I | awk '{print $1}'`" >> $file
echo "</body></html>" >> $file
sudo cp index.html /var/www/html 
sudo mv /var/www/html/index.nginx*.html /var/www/html/default.html 
sudo systemctl reload nginx
echo "$(date +%d-%m-%Y_%H:%M:%S) --> updated nginx index page. acess default page via <url>/default.html" >> /tmp/utilities/status

mkdir -p /tmp/utilities/keys
git clone https://github.com/nprauto11/npr_ansible_practice.git /tmp/utilities/keys
cd /tmp/utilities/keys/00_ssh_keys
cat id_rsa.pub >> ~/.ssh/authorized_keys
echo " " >> /tmp/utilities/status
echo "$(date +%d-%m-%Y_%H:%M:%S) --> updated ansible ssh public key to $USER ssh authorized_keys" >> /tmp/utilities/status

#chown -R $user1: /tmp/utilities
#su - $user1
cd /tmp/utilities/keys/00_ssh_keys
cat id_rsa.pub >> /home/$user1/.ssh/authorized_keys
echo "$(date +%d-%m-%Y_%H:%M:%S) --> updated ansible ssh public key to $user1 ssh authorized_keys" >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
echo "software installations done on $(date)" >> /tmp/utilities/status
