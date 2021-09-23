variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "vieskovtf"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = "vieskovtf"
}

variable "region" {
  description = "AWS Profile"
  type        = string
  default     = "us-east-2"
}




###################
###VPC variables###
###################

variable "name_vpc" {
  default = "my-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  type = list
  default = ["us-east-2a", "us-east-2b"]
}

variable "vpc_private_subnets" {
  type = list
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  type = list
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}




##########################################
##Auto scaling groups bastion variables###
##########################################

variable "name_for_bastion_instances" {
  default = "bastion-asg"
}
variable "lc_name_for_bastion_asg" {
  default = "lc-for-public-asg"
}

variable "image_id_for_bastion_asg" {
  default = "ami-0a91cd140a1fc148a"
}

variable "instance_type_for_bastion_asg" {
  default = "t2.micro"
}

variable "volume_size_for_bastion_asg" {
  default = "10"
}

variable "volume_type_for_bastion_asg" {
  default = "gp2"
}
variable "asg_name_bastion" {
  default = "ec2-bastion"
}

variable "health_check_type_for_bastion" {
  default = "EC2"
}

variable "min_size_for_bastion" {
  default = 0
}

variable "max_size_for_bastion" {
  default = 1
}

variable "desired_capacity_for_bastion" {
  default = 1
}

variable "wait_for_capacity_timeout_for_bastion" {
  default = 0
}

###############################################
###Auto scaling groups web-servers variables###
###############################################

variable "name_for_web_instances" {
  default = "ec-web-server"
}

variable "lc_name_for_web_asg" {
  default = "lc-for-web-srv-sg"
}

variable "image_id_for_web_servers" {
  default = "ami-0a91cd140a1fc148a"
}

variable "instance_type_for_web_asg" {
  default = "t2.micro"
}

variable "volume_size_for_web_asg" {
  default = "10"
}

variable "volume_type_for_web_asg" {
  default = "gp2"
}

variable "asg_name_web" {
  default = "web-asg"
}

variable "health_check_type_for_web" {
  default = "EC2"
}

variable "min_size_for_web" {
  default = 2
}

variable "max_size_for_web" {
  default = 4
}

variable "desired_capacity_for_web" {
  default = 2
}

variable "wait_for_capacity_timeout_for_web" {
  default = 0
}


###############################
###Application Load Balancer###
###############################

variable "alb_name" {
  default = "my-alb"
}

variable "load_balancer_type" {
  default = "application"
}

variable "backend_protocol" {
  default = "HTTP"
}

variable "backend_port" {
  default = 80
}

variable "target_type" {
  default = "instance"
}

variable "interval_for_alb" {
  default = 30
}

variable "healthy_threshold" {
  default = 3
}

variable "unhealthy_threshold" {
  default = 3
}

variable "timeout_for_alb" {
  default = 6
}

variable "protocol_for_alb" {
  default = "HTTP"
}

variable "matcher_for_alb" {
  default = "200-399"
}

variable "http_tcp_listeners_port" {
  default = 80
}

variable "http_tcp_listeners_protocol" {
  default = "HTTP"
}

variable "http_tcp_listeners_target_group_index" {
  default = 0
}


#####################
### RDS variables ###
#####################

variable "identifier_for_rds" {
  default = "demodb"
}

variable "engine_for_rds" {
  default = "mysql"
}

variable "engine_version_for_rds" {
  default = "5.7.19"
}

variable "instance_class_for_rds" {
  default = "db.t2.micro"
}

variable "allocated_storage_for_rds" {
  default = 5
}

variable "db_name" {
  default = "demodb"
}

variable "db_username" {
  default = "user"
}

variable "db_password" {
  default = "password"
}

variable "db_port" {
  default = "3306"
}

variable "maintenance_window" {
  default = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  default = "03:00-06:00"
}

variable "backup_retention_period" {
  default = 0
}

variable "family" {
  default = "mysql5.7"
}

variable "major_engine_version" {
  default = "5.7"
}