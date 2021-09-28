#!bin/bash
#set -e # Exit on first error
set -x # Print expanded commands to stdout

#install git
apt install -y git

#install ansible
apt-add-repository -y ppa:ansible/ansible
apt update
apt install -y ansible





#install make
apt-get update
apt-get install -y make

#install gcc
apt update && apt dist-upgrade -y
apt install -y build-essential

#install maven
apt-get update && apt-get upgrade
apt-get  install -y  maven

#install gradle
add-apt-repository -y  ppa:cwchien/gradle
apt-get update
apt-get install -y gradle

ansible-galaxy install geerlingguy.java
ansible-galaxy install geerlingguy.jenkins
ansible-galaxy install geerlingguy.solr
ansible-galaxy install blackstar257.perl

cd ~
git clone https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git





#install docker
cp -r ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker ~/.ansible/roles
cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker.yml ~/.ansible/
ansible-playbook ~/.ansible/install_docker.yml







cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_solr.yml ~/.ansible/
cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_perl.yml ~/.ansible/

ansible-playbook ~/.ansible/install_solr.yml
ansible-playbook ~/.ansible/install_perl.yml

 
