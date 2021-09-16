#!/bin/bash
#sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible


#ansible-galaxy install geerlingguy.docker
ansible-galaxy install geerlingguy.java
#ansible-galaxy install geerlingguy.jenkins
#ansible-galaxy install geerlingguy.postgresql

ansible-playbook install_java.yml -K


