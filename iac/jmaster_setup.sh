#!/bin/bash

# Some sane options.
set -e # Exit on first error.
set -x # Print expanded commands to stdout.

apt install -y git

apt-add-repository -y ppa:ansible/ansible
apt update
apt install -y ansible

ansible-galaxy install geerlingguy.java
ansible-galaxy install geerlingguy.jenkins

cd ~
git clone https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git

#install Jenkins
cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_jenkins.yml ~/.ansible/
ansible-playbook ~/.ansible/install_jenkins.yml
#install docker
cp -r ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker ~/.ansible/roles
cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker.yml ~/.ansible/
ansible-playbook ~/.ansible/install_docker.yml
#install Jenkins config and jobs
cd ~/DevOps_internal_Dnipro_2021Q3
cp -r jenkins_config     /var/lib/jenkins
#add jenkins to docker group
usermod -aG docker jenkins
reboot


     
        

