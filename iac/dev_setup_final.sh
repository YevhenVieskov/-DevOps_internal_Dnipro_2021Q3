#!/bin/bash

# Some sane options.
set -e # Exit on first error.
set -x # Print expanded commands to stdout.

sudo apt install -y git
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible

cd ~
git clone https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git

#install docker
#ansible-pull -U https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git -C dev -i 192.168.0.106 requirements.yml
#ansible-galaxy install  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker.yml
cp -r ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker ~/.ansible/roles
cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker.yml ~/.ansible/
ansible-playbook ~/.ansible/install_docker.yml

     
        

