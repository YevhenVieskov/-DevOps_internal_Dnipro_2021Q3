#!/bin/bash

# Some sane options.
set -e # Exit on first error.
set -x # Print expanded commands to stdout.

function pbook {
   # Set our named arguments.
   declare -r url=$1 playbook=$2 host=$3
   /usr/local/bin/ansible-pull --accept-host-key --verbose \
    --url "$url" -i localhost --directory /var/local/src/instance-bootstrap "$playbook"
}




#sudo apt install -y git
#sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible


#install docker

pbook \  
  'https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git' \    
  'ansible/requirements.yml'

ansible-galaxy install -r /var/local/src/instance-bootstraprequirements.yml
         
pbook \  
  'https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git' \    
  'ansible/install_docker.yml'
     
        

