#!/bin/bash

##################################################################################################
# Scrit_Name: install.sh                                                                         #
# Maintainer: nprauto11                                                                          #
# Description: installing on ubuntu 22.04-->  jenkins, tomcat, nginx, maven, awscli, docker-cli, #
#               docker-compose, terraform  (with existed:- git, python3)                         #
# version: v1                                                                                    #
##################################################################################################

user1=ubuntu
mkdir -p /tmp/utilities/softwares && cd /tmp/utilities/softwares
echo "software installations started on $(date)" > /tmp/utilities/status
echo " " >> /tmp/utilities/status

# nginx, maven, awscli, curl
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
sudo apt install awscli maven nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx 
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed maven, awscli,nginx & started nginx service. Access via port 80" >> /tmp/utilities/status

file=index.html
echo "<html><head><title>index</title></head><body>" > $file 
echo "&nbsp" >> $file
echo "<h1> Hi! welcome everyone!</h1>" >> $file
echo "<h2>below are host (master) Details:-</h2>" >> $file
echo "<p>public_ip-adress: $(curl ifconfig.me)" >> $file
echo "&nbsp </p>" >> $file
echo "local_ip-address: `hostname -I | awk '{print $1}'`" >> $file
echo "</body></html>" >> $file
sudo cp index.html /var/www/html 
sudo mv /var/www/html/index.nginx*.html /var/www/html/default.html 
sudo systemctl reload nginx
echo "$(date +%d-%m-%Y_%H:%M:%S) --> updated nginx index page. acess default page via <url>/default.html" >> /tmp/utilities/status


# ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install ansible -y
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed ansible" >> /tmp/utilities/status


# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce -y
sudo usermod -aG docker ${USER}  
sudo usermod -aG docker $user1
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed docker-cli" >> /tmp/utilities/status

# docker-compose 
sudo apt install python3-pip -y
sudo pip3 install docker-compose
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed docker-compose" >> /tmp/utilities/status

# terraform 
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y && sudo apt install terraform
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed terraform" >> /tmp/utilities/status


# jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null	
sudo apt-get update
sudo apt-get install fontconfig openjdk-11-jre -y
sudo apt-get install jenkins -y 
sudo systemctl enable jenkins
sudo systemctl start jenkins
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed jenkins & started service. Access via port 8080" >> /tmp/utilities/status


# tomcat
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
VERSION=9.0.73
wget https://downloads.apache.org/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz /tmp 
sudo tar -xf apache-tomcat-${VERSION}.tar.gz -C /opt/tomcat/
sudo mv /opt/tomcat/apache-tomcat-${VERSION} /opt/tomcat/latest

touch tomcat-users.xml
cat <<EOT >> tomcat-users.xml
<?xml version="1.0" encoding="UTF-8"?>

<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">

  <role rolename="admin-gui"/>
  <role rolename="manager-gui"/>
  <user username="admin" password="admin" roles="admin-gui,manager-gui"/>
</tomcat-users>
EOT

sudo rm -rf /opt/tomcat/latest/conf/tomcat-users.xml
sudo chmod 600 tomcat-users.xml
sudo cp tomcat-users.xml /opt/tomcat/latest/conf/
sudo chown -R tomcat: /opt/tomcat
sudo sed -i 's/8080/9080/g' /opt/tomcat/latest/conf/server.xml

sudo sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' /opt/tomcat/latest/webapps/manager/META-INF/context.xml
sudo sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' /opt/tomcat/latest/webapps/host-manager/META-INF/context.xml   
sudo sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' /opt/tomcat/latest/webapps/examples/META-INF/context.xml
sudo sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' /opt/tomcat/latest/webapps/docs/META-INF/context.xml


touch tomcat.service
cat <<EOT >> tomcat.service
[Unit]
Description=Tomcat 9 servlet container
After=network.target
[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"
Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh
[Install]
WantedBy=multi-user.target
EOT
sudo cp tomcat.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now tomcat
systemctl start tomcat
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed tomcat & started service. Access via port 9080" >> /tmp/utilities/status

# deploy jenkins on tomcat 
# https://raw.githubusercontent.com/AKSarav/SampleWebApp/master/dist/SampleWebApp.war
wget https://get.jenkins.io/war-stable/2.387.2/jenkins.war
sudo chown tomcat: jenkins.war
sudo cp -p jenkins.war /opt/tomcat/latest/webapps/

echo "$(date +%d-%m-%Y_%H:%M:%S) --> deployed jenkins war as webapp on tomcat. Access by <host_url>:9080/jenkins " >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
sudo systemctl stop jenkins
sudo systemctl stop tomcat
echo "$(date +%d-%m-%Y_%H:%M:%S) --> stopped jenkins & tomcat. if needed start service manually" >> /tmp/utilities/status
echo " " >> /tmp/utilities/status

# configure ansible 
mkdir -p /tmp/utilities/keys
git clone https://github.com/nprauto11/npr_ansible_practice.git /tmp/utilities/keys
chown -R $USER:$USER /tmp/utilities/keys
cd /tmp/utilities/keys/00_ssh_keys
chmod 400 id_rsa 
cp -p  id_rsa id_rsa.pub ~/.ssh/
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
echo "$(date +%d-%m-%Y_%H:%M:%S) --> copied ssh keys & updated public key to authorized_keys of user:" ${USER} >> /tmp/utilities/status



#cd /tmp && chown -R $user1 utilities
#su - $user1
#cd /tmp/utilities/keys/00_ssh_key
#cp id_rsa id_rsa.pub ~/.ssh/

chown -R $user1:$user1 /tmp/utilities/keys
cd /tmp/utilities/keys/00_ssh_keys
cp -p  id_rsa id_rsa.pub /home/$user1/.ssh/
cat /home/$user1/.ssh/id_rsa.pub >> /home/$user1/.ssh/authorized_keys
echo "$(date +%d-%m-%Y_%H:%M:%S) --> copied ssh keys & updated public key to authorized_keys of user:" $user1 >> /tmp/utilities/status

echo " " >> /tmp/utilities/status
echo "software installations done on $(date)" >> /tmp/utilities/status

#########################################
# and need to do afer script execution:- 
#  replace old with new content (if tomcat not working)
#  
#  sudo ls -l /opt/tomcat/latest/webapps/manager/META-INF/context.xml
#  sudo ls -l /opt/tomcat/latest/webapps/host-manager/META-INF/context.xml   
#  sudo ls -l /opt/tomcat/latest/webapps/examples/META-INF/context.xml
#  sudo ls -l /opt/tomcat/latest/webapps/docs/META-INF/context.xml
#  
#   
#   # context.xml
#   old:
#   <Valve className="org.apache.catalina.valves.RemoteAddrValve"
#     allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
#   
#   new: 
#   <Valve className="org.apache.catalina.valves.RemoteAddrValve"
#     allow="\d+\.\d+\.\d+\.\d+" />
#
#   new1: 
#   <Valve className="org.apache.catalina.valves.RemoteAddrValve"
#     allow=".*" />
#
#   new2: 
#   <!--
#   <Valve className="org.apache.catalina.valves.RemoteAddrValve"
#     allow=".*" />
#    -->     
#     
#
# sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' content.xml
#
# sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!-- & -->/;ty;P;D;:y}}' content.xml
#
# sed -r '/^\s*<Valve className\s*=\s*"org\.apache\.catalina\.valves\.RemoteAddrValve"\s*$/{h;z;N;s:^\n::;H;/^\s*allow\s*=\s*"127\\\.\\d\+\\\.\\d\+\\\.\\d\+\|::1\|0:0:0:0:0:0:0:1"\s*\/>\s*$/{g;s/.*/<!--\n&\n-->/}}' context.xml
#
#   
#########################################






