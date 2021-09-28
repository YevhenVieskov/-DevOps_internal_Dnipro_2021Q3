
#variables
variable "profile" {
  description = "AWS Profile"
  type        = string
  default     = "vieskovtf"
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
  default     = "us-east-2"
}



#################
# Network
#################


variable "vpc_name" {
  description = "Name to be used for the Jenkins master instance"
  type        = string
  default     = "vpc-app"
}

variable "vpc_cidr" {
  type        = string
  default = "192.168.0.0/16"
}



variable "pub_a" {
  description = "subnet"
  type        = string
  default     = "192.168.1.0/24"
}


variable "pub_b" {
  description = "subnet"
  type        = string
  default     = "192.168.2.0/24"
}

variable "pvt_a" {
  description = "subnet"
  type        = string
  default     = "192.168.3.0/24"
}

variable "pvt_b" {
  description = "subnet"
  type        = string
  default     = "192.168.4.0/24"
}

 

variable "name" {
  description = "EC2 instance name"
  type        = string
  default     = "jenkins"
}



variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = "vieskovtf"
}

variable "instance_type" {
  description = "Instance Type to use for Jenkins master"
  type        = string
  default     = "t2.micro"
}


variable "env" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}


variable "tags" {
  description = "Tags to apply to all the resources"
  type        = map

  default = {
    Terraform = "true"
  }
}

variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections to Jenkins"
  type        = string
  default     = "0.0.0.0/0"
}

#################
# User Data
#################

variable "udata_asg" {
  description = "Name to be used for the Jenkins master instance"
  type        = string
  default     = "./ec2_setup.sh"
}


#################
# Route 53
#################

variable "domain_name" {
  description = "domain_name"
  type        =  string
  default     = "vieskovtf.com"
}

variable "zone_name" {
  description = "Route 53 zone name"
  type        =  string
  default     = "vieskovtf"  
}

variable "zone_id" {
  description = "Route 53 zone id"
  type        = string
  default     = "id-6789ZXCV"  
}

variable "hosted_zone_id" {
  description = "Route 53 zone id"
  type        = string
  default     = "id-6789ZXCV"  
}

variable "create_certificate" {
  description = "Create ACM certificate"
  type        = bool
  default     = false
}

variable "wait_for_validation" {
  description = "Validation ACM certificate"
  type        = bool
  default     = true
}




/*variable "public_zone_id" {
  description = "public zone id"
  type        = string
  default     = "Z1WA3EVJBXSQ2V"
}

variable "private_zone_id" {
  description = "Instance Type to use for Jenkins master"
  type        = string
  default     = "Z3CVA9QD5NHSW3"
}*/


variable "ssl_certificate_id" {
  description = "Certificate for load balancer"
  type        = string
  default     = "arn:aws:acm:us-east-2:052776272001:certificate/5f64bc59-ee3e-4202-86e0-0edbb6f0afe7" 
}

#################
# Bastion
#################
variable "bucket_bastion" {
  description = "bastion_bucket"
  type        = string
  default     = "bucket-bastion-dev"
}

variable "bastion_volume_size" {
  description = "bastion_volume_size"
  type        = number
  default    =   10                    
}


#################
# ALB
#################
variable "alb_name" {
  default = "app-alb"
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


#################
# ASG
#################

variable "name_for_web_instances" {
  default = "ec-web-server"
}

variable "lc_name_for_web_asg" {
  default = "lc-for-web-srv-sg"
}

/*variable "image_id_for_web_servers" {
  default = "ami-0a91cd140a1fc148a"
}*/

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



#################
# Database
#################
variable "db_identifier" {
  description = "Database name"
  type        = string
  default     = "webdb"
}


variable "db_engine" {
  description = "Database engine"
  type        = string
  default     ="postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     ="11.10"
}

variable "db_family" {
  description = "Database family"
  type        = string
  default    = "postgres11"
}

variable "db_major_engine_version" {
  description = "Database major engine version"
  type        = string
  default    = "11" 
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default    =  "db.t3.large"  
}

variable "db_allocated_storage" {
  description = "Database allocated storage"
  type        = number
  default    =   20                    
}

variable "db_max_allocated_storage" {
  description = "Database max allocated storage"
  type        = number
  default    =   100                    
}

variable "db_storage_encrypted" {
  description = "Database storage encrypted"
  type        = bool
  default    =   false                    
}

variable "db_name" {
  description = "Database name"
  type        =  string
  #default   =  "completePostgresql"
}


variable "db_username" {
  description = "Database username"
  type        =  string
  #default   = "complete_postgresql"
}

variable "db_password" {
  description = "Database password"
  type        =  string
  #default   = "YourPwdShouldBeLongAndSecure!"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default    =   5432                    
}

variable "db_multi_az" {
  description = "Database multi available zone"
  type        = bool
  default    =   true                    
}

variable "db_maintenance_window" {
  description = "Database username"
  type        =  string
  default   = "Mon:00:00-Mon:03:00"
}

variable "db_backup_window" {
  description = "Database username"
  type        =  string
  default   = "03:00-06:00"
}

variable "db_enabled_cloudwatch_logs_exports" {
  description = "Database enabled cloudwatch logs exports"
  type        =  list
  default   = ["postgresql", "upgrade"]
}

variable "db_backup_retention_period" {
  description = "Database backup retention period"
  type        = number
  default    =   0                   
}

variable "db_skip_final_snapshot" {
  description = "Database skip final snapshot"
  type        = bool
  default    =   true                    
}

variable "db_deletion_protection" {
  description = "Database deletion protection"
  type        = bool
  default    =   false                    
}

variable "db_performance_insights_enabled" {
  description = "Database  performance insights enabled"
  type        = bool
  default    =   true                   
}

variable "db_performance_insights_retention_period" {
  description = "Database performance insights retention period"
  type        = number
  default    =   7                   
}

variable "db_create_monitoring_role" {
  description = "Database deletion protection"
  type        = bool
  default    =   true                    
}

variable "db_monitoring_interval" {
  description = "Database monitoring interval "
  type        = number
  default    =   60                   
}

variable "db_monitoring_role_name" {
  description = "Database monitoring role name"
  type        =  string
  default   ="example-monitoring-role-name"
}

variable "db_monitoring_role_description" {
  description = "monitoring_role_description"
  type        =  string
  default   = "Description for monitoring role"
}














########################################################




variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections on SSH"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "ssh_port" {
  description = "The port used for SSH connections"
  type        = number
  default     = 22
}

variable "http_port" {
  description = "The port to use for HTTP traffic to Jenkins"
  type        = number
  default     = 80
}

variable "http_jenkins_port" {
  description = "The port to use for HTTP traffic to Jenkins"
  type        = number
  default     = 8080
}

variable "https_port" {
  description = "The port to use for HTTPS traffic to Jenkins"
  type        = number
  default     = 443
}

variable "jnlp_port" {
  description = "The port to use for TCP traffic between Jenkins intances"
  type        = number
  default     = 49187
}










