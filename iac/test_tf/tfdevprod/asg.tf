module "public-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name_for_bastion_instances

  # Launch configuration
  lc_name = var.lc_name_for_bastion_asg

  image_id        = data.aws_ami.ubuntu.id
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
    Environment = var.env
  }
}

resource "aws_launch_template" "web-app-template2" {
  name = "run-web-app2"
  #name_prefix   = "terraform-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_for_web_asg
  key_name      = var.ssh_key_name  
  user_data              = var.udata_asg != "" ? base64encode(var.udata_asg) : base64encode(file(var.udata_asg))

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [module.web-sg.security_group_id]
  }
}

/*module "private-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name_for_web_instances

  # Launch configuration
  #lc_name = var.lc_name_for_web_asg

  /*image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type_for_web_asg
  security_groups = [module.web-sg.security_group_id]*/
  
  

  /*root_block_device = [
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
  #key_name                  = var.ssh_key_name 
  target_group_arns         = module.alb.target_group_arns

  # Launch template  
  use_lt    = true
  create_lt = false  
  launch_template = aws_launch_template.web-app-template.name

  tags_as_map = {
    Owner       = "Terraform"
    Environment = var.env
  }
}*/

module "private-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = var.name_for_web_instances

  min_size                  = var.min_size_for_web
  max_size                  = var.max_size_for_web
  desired_capacity          = var.desired_capacity_for_web
  wait_for_capacity_timeout = var.wait_for_capacity_timeout_for_web
  health_check_type         = var.health_check_type_for_web
  vpc_zone_identifier       = module.vpc.private_subnets

  target_group_arns        = module.alb.target_group_arns

  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  #lt_name                = "web-app-template"
  #description            = "Launch template example"
  #update_default_version = true

  use_lt    = true
  create_lt = false  
  launch_template = aws_launch_template.web-app-template2.name

  image_id          = data.aws_ami.ubuntu.id 
  instance_type     = var.instance_type_for_web_asg
  ebs_optimized     = true
  enable_monitoring = true

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 50
        volume_type           = "gp2"
      }
      }, {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 50
        volume_type           = "gp2"
      }
    }
  ]

  /*capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification = {
    cpu_credits = "standard"
  }

  instance_market_options = {
    market_type = "spot"
    spot_options = {
      block_duration_minutes = 60
    }
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }*/

  /*network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.autoscaling.security_group_id]
    },
    {
      delete_on_termination = true
      description           = "eth1"
      device_index          = 1
      security_groups       = [module.autoscaling.security_group_id]
    }
  ]*/

  /*placement = {
    availability_zone = "${var.region}b"
  }*/

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { WhatAmI = "Volume" }
    },
    {
      resource_type = "spot-instances-request"
      tags          = { WhatAmI = "SpotInstanceRequest" }
    }
  ]

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}