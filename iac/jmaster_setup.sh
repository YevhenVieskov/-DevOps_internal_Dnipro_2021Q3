#!/bin/bash

# Some sane options.
set -e # Exit on first error.
set -x # Print expanded commands to stdout.

#install git
apt install -y git

#install ansible
apt-add-repository -y ppa:ansible/ansible
apt update
apt install -y ansible

#install jq
apt update
install jq

#install make
apt-get update
apt-get install -y  make

#install gcc
sudo apt update && sudo apt dist-upgrade
sudo apt install -y  build-essential

#gcc variant
#add-apt-repository -y ppa:ubuntu-toolchain-r/test && sudo apt update
#sudo apt -y install gcc-snapshot && sudo apt -y install gcc-11g++-11

#gcc variant 2
#sudo apt-get install -y software-properties-common
#sudo add-apt-repository ppa:ubuntu-toolchain-r/test
#sudo apt update
#sudo apt install g++-7 -y

#install maven
apt-get update && apt-get upgrage
apt-get -y install maven

#install gradle
add-apt-repository ppa:cwchien/gradle
apt-get update
apt-get install gradle



ansible-galaxy install geerlingguy.java
ansible-galaxy install geerlingguy.jenkins
ansible-galaxy install geerlingguy.solr
ansible-galaxy install blackstar257.perl

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
cp -r jenkins_config/*     /var/lib/jenkins
#add jenkins to docker group
usermod -aG docker jenkins



reboot


     
        

