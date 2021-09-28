module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "${var.env}${var.name_for_web_instances}"

  # Launch configuration
  lc_name = var.lc_name_for_web_asg

  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type_for_web_asg
  security_groups = [module.web.security_group_id]
  #user_data       = var.udata_asg != "" ? base64encode(var.udata_asg) : base64encode(file(var.udata_asg))
  user_data       = <<-EOF
                #!/bin/bash
                #ec2ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
                #echo "<html> <body bgcolor=0FA2B6><center><h1><p><font color=White>$ec2ip</h1><center></body></html>" > index.html
                #nohup busybox httpd -f -p 80 &
                apt install -y git
                apt-add-repository -y ppa:ansible/ansible
                apt update
                apt install -y ansible
                cd ~
                git clone https://github.com/YevhenVieskov/DevOps_internal_Dnipro_2021Q3.git
                cp -r ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker ~/.ansible/roles
                cp  ~/DevOps_internal_Dnipro_2021Q3/ansible/install_docker.yml ~/.ansible/
                ansible-playbook ~/.ansible/install_docker.yml
                EOF

  root_block_device = [
    {
      volume_size = var.volume_size_for_web_asg
      volume_type = var.volume_type_for_web_asg
    },
  ]

  # Auto scaling group
  asg_name                  = var.asg_name_web
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = var.health_check_type_for_web
  min_size                  = var.min_size_for_web
  max_size                  = var.max_size_for_web
  desired_capacity          = var.desired_capacity_for_web
  wait_for_capacity_timeout = var.wait_for_capacity_timeout_for_web
  key_name                  = var.ssh_key_name 
  target_group_arns         = module.app_alb.target_group_arns


  tags_as_map = {
    Owner       = "Terraform"
    Environment = var.env
  }
}