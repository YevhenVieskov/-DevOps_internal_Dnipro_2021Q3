module "jmaster_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.jmname

  ami                    = data.aws_ami.ubuntu.id  
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  key_name               = var.ssh_key_name
  monitoring             = true
  vpc_security_group_ids = [module.jenkins_master_sg.security_group_id]       #module.vpc.public_subnets    
  subnet_id              = module.vpcjk.public_subnets[1] 

  #user_data              = var.udata_jmaster != "" ? base64encode(var.udata_jmaster) : base64encode(file(var.udata_jmaster))

  user_data       = <<-EOF
                #!/bin/bash
                #apt install -y git
                sudo apt-add-repository -y ppa:ansible/ansible
                sudo apt update
                sudo apt install -y ansible
                sudo apt update
                sudo apt install -y  jq
                ansible-galaxy install geerlingguy.java
                ansible-galaxy install geerlingguy.jenkins
                cd ~
                git clone https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git
                cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_jenkins.yml ~/.ansible/
                ansible-playbook ~/.ansible/install_jenkins.yml
                cp -r ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker ~/.ansible/roles
                cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker.yml ~/.ansible/
                ansible-playbook ~/.ansible/install_docker.yml
                usermod -aG docker jenkins
                cd ~/DevOps_internal_Dnipro_2021Q3
                cp -r jenkins_config/*     /var/lib/jenkins                
                reboot 
                EOF
  

  /*root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }*/

  tags = {
    Terraform   = "true"
    Environment = var.jmname
  }
}


module "jslave_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.jsname

  ami                    = data.aws_ami.ubuntu.id  
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  key_name               = var.ssh_key_name
  monitoring             = true
  vpc_security_group_ids = [module.jenkins_master_sg.security_group_id]   
  subnet_id              = module.vpcjk.private_subnets[1] 

  #user_data              = var.udata_jslave != "" ? base64encode(var.udata_jslave) : base64encode(file(var.udata_jslave)) 

  user_data       = <<-EOF
                #!/bin/bash
                #apt install -y git
                sudo apt-add-repository -y ppa:ansible/ansible
                sudo apt update
                sudo apt install -y ansible
                sudo apt update                
                ansible-galaxy install geerlingguy.java                
                EOF

  /*root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }*/

  tags = {
    Terraform   = "true"
    Environment = var.jsname
  }
}




