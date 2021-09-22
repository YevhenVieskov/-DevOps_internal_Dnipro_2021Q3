module "public-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name_for_bastion_instances

  # Launch configuration
  lc_name = var.lc_name_for_bastion_asg

  image_id        = var.image_id_for_bastion_asg
  instance_type   = var.instance_type_for_bastion_asg
  security_groups = [module.bastion-sg.security_group_id] 

  root_block_device = [
    {
      volume_size = var.volume_size_for_bastion_asg
      volume_type = var.volume_type_for_bastion_asg
    },
  ]

  # Auto scaling group
  asg_name                  = var.asg_name_bastion
  vpc_zone_identifier       = module.vpc.public_subnets
  health_check_type         = var.health_check_type_for_bastion
  min_size                  = var.min_size_for_bastion
  max_size                  = var.max_size_for_bastion
  desired_capacity          = var.desired_capacity_for_bastion
  wait_for_capacity_timeout = var.wait_for_capacity_timeout_for_bastion
  key_name                  = var.ssh_key_name

  tags_as_map = {
    Owner       = "inception"
    Environment = "dev"
  }
}

module "private-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name_for_web_instances

  # Launch configuration
  lc_name = var.lc_name_for_web_asg

  image_id        = var.image_id_for_web_servers
  instance_type   = var.instance_type_for_web_asg
  security_groups = [module.web-sg.security_group_id]
  user_data       = <<-EOF
                #!/bin/bash
                ec2ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
                echo "<html> <body bgcolor=0FA2B6><center><h1><p><font color=White>$ec2ip</h1><center></body></html>" > index.html
                nohup busybox httpd -f -p 80 &
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
  target_group_arns         = module.alb.target_group_arns


  tags_as_map = {
    Owner       = "inception"
    Environment = "prod"
  }
}