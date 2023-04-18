#!/bin/bash  

##################################################################################################
# Scrit_Name: ubuntu22_aws_userdata_install-soft.sh                                              #                          #
# Maintainer: nprauto11                                                                          #
# Description: installing on ubuntu 22.04-->  jenkins, tomcat, nginx, maven, awscli, docker-cli, #
#               docker-compose, terraform  (with existed:- git, python3)                         #
#               This useful script for userdata on AWS ec2 spin-up                               #         
# version: v1                                                                                    #
##################################################################################################


user1=ubuntu
mkdir /tmp/softwares && cd /tmp/softwares
echo "software installations started on $(date)" > status
echo " " >> status

# nginx, maven, awscli, curl
apt update -y
apt install apt-transport-https ca-certificates curl software-properties-common -y
apt install awscli maven nginx -y
systemctl enable nginx
systemctl start nginx 
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed maven, awscli,nginx & started nginx service. Access via port 80" >> status

# ansible
apt-add-repository ppa:ansible/ansible -y
apt update -y 
apt install ansible -y
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed ansible" >> status


# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce -y
usermod -aG docker ${USER} 
usermod -aG docker $user1id 
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed docker-cli" >> status

# docker-compose 
apt install python3-pip -y
pip3 install docker-compose
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed docker-compose" >> status

# terraform 
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y && sudo apt install terraform
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed terraform" >> status

# jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null	
apt-get update
apt-get install fontconfig openjdk-11-jre -y
apt-get install jenkins -y 
systemctl enable jenkins
systemctl start jenkins
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed jenkins & started service. Access via port 8080" >> status

# tomcat
useradd -m -U -d /opt/tomcat -s /bin/false tomcat
VERSION=9.0.73
wget https://downloads.apache.org/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz /tmp 
tar -xf apache-tomcat-${VERSION}.tar.gz -C /opt/tomcat/
mv /opt/tomcat/apache-tomcat-${VERSION} /opt/tomcat/latest

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

rm -rf /opt/tomcat/latest/conf/tomcat-users.xml
chmod 600 tomcat-users.xml
cp tomcat-users.xml /opt/tomcat/latest/conf/
chown -R tomcat: /opt/tomcat
sed -i 's/8080/9080/g' /opt/tomcat/latest/conf/server.xml

sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' /opt/tomcat/latest/webapps/manager/META-INF/context.xml
sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' /opt/tomcat/latest/webapps/host-manager/META-INF/context.xml   
sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' /opt/tomcat/latest/webapps/examples/META-INF/context.xml
sed -i '{$!{N;s/<Valve.*\n.*allow.* \/>/<!--\n&\n-->/;ty;P;D;:y}}' /opt/tomcat/latest/webapps/docs/META-INF/context.xml


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
cp tomcat.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable --now tomcat
systemctl start tomcat
echo "$(date +%d-%m-%Y_%H:%M:%S) --> installed tomcat & started service. Access via port 9080" >> status


# jenkins war file deploy on tomcat 
# https://raw.githubusercontent.com/AKSarav/SampleWebApp/master/dist/SampleWebApp.war
wget https://get.jenkins.io/war-stable/2.387.2/jenkins.war
chown tomcat: jenkins.war
cp -p jenkins.war /opt/tomcat/latest/webapps/
echo "$(date +%d-%m-%Y_%H:%M:%S) --> deployed jenkins war file as tomcat webapp. Access by <host_ip>:9080/jenkins" >> status

echo " " >> status
echo "software installations done on $(date)" >> status