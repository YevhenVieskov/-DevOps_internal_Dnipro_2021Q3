#!/bin/bash

# Some sane options.
set -e # Exit on first error.
set -x # Print expanded commands to stdout.

apt install -y git
#sudo apt-get install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt update
apt install -y ansible

ansible-galaxy install geerlingguy.java
ansible-galaxy install geerlingguy.jenkins

cd ~
git clone https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git
cd ~/DevOps_internal_Dnipro_2021Q3
cp -r jenkins_congig     /var/lib/jenkins


     
        

