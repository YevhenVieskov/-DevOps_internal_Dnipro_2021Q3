#!/bin/bash

#install ansible
sudo apt-get update
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible

#install git
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get install -y git
cd ~/
#git clone https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git



#ansible-galaxy install geerlingguy.docker


