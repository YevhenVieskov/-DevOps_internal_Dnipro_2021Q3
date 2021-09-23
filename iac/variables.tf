
#################
# Credentials
#################
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

variable "region_jenkins" {
  description = "Region for AWS Jenkins network "
  type        = string
  default     = "us-east-2"
}

variable "region_peer" {
  description = "Region for AWS dev and prod environments"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone_jenkins" {
  description = "Region for AWS resources"
  type        = string
  default     = "us-east-2b"
}

variable "region_dev" {
  description = "Region for AWS dev network "
  type        = string
  default     = "us-east-2"
}

variable "region_prod" {
  description = "Region for AWS dev network "
  type        = string
  default     = "us-east-2"
}





#################
# Environment
#################

variable "env_jenkins" {
  description = "Environment tag"
  type        = string
  default     = "jenkins"
}

variable "env_dev" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "env_prod" {
  description = "Environment tag"
  type        = string
  default     = "prod"
}



#################
# Tags
#################

variable "tags" {
  description = "Tags to apply to all the resources"
  type        = map

  default = {
    Terraform = "true"
  }
}

#################
# Instance names
#################

variable "jmname" {
  description = "Name of jenkins master"
  type        = string
  default     = "jenkins-master"
}

variable "jsname" {
  description = "Name of jenkins master"
  type        = string
  default     = "jenkins-slave"
}

variable "alb_name_dev" {
  description = "Name of jenkins master"
  type        = string
  default     = "alb-app-dev"
}

variable "alb_name_prod" {
  description = "Name of jenkins master"
  type        = string
  default     = "alb-app-prod"
}



#################
# Instance type
#################

variable "instance_type_jenkins" {
  description = "Instance Type to use for Jenkins master"
  type        = string
  default     = "t2.micro"
}

variable "instance_type_dev" {
  description = "Instance Type to use for dev"
  type        = string
  default     = "t2.micro"
}

variable "instance_type_prod" {
  description = "Instance Type to use for prod"
  type        = string
  default     = "t2.micro"
}



#################
# Network Jenkins
#################

variable "vpc_cidr_jenkins" {
  type        = string
  default = "10.0.0.0/16"
}


variable "pub_a_jenkins" {
  description = "subnet Jenkins master"  
  type        = string
  default     = "10.0.1.0/24"
}


variable "pub_b_jenkins" {
  description = "subnet Jenkins master"
  type        = string
  default     = "10.0.2.0/24"
}

variable "pvt_a_jenkins" {
  description = "subnet Jenkins slave"
  type        = string
  default     = "10.0.3.0/24"
}

variable "pvt_b_jenkins" {
  description = "subnet Jenkins slave"
  type        = string
  default     = "10.0.4.0/24"
}

#################
# Network dev
#################

variable "vpc_name_dev" {
  description = "VPC for dev environment"
  type        = string
  default     = "vpc-app-dev"
}

variable "vpc_cidr_dev" {
  type        = string
  default = "10.1.0.0/16"
}

variable "pub_a_dev" {
  description = "subnet"
  type        = string
  default     = "10.1.1.0/24"
}


variable "pub_b_dev" {
  description = "subnet"
  type        = string
  default     = "10.1.2.0/24"
}

variable "pvt_a_dev" {
  description = "subnet"
  type        = string
  default     = "10.1.3.0/24"
}

variable "pvt_b_dev" {
  description = "subnet"
  type        = string
  default     = "10.1.4.0/24"
}

#################
# Network prod
#################

variable "vpc_name_prod" {
  description = "VPC for dev environment"
  type        = string
  default     = "vpc-app-dev"
}

variable "vpc_cidr_prod" {
  type        = string
  default = "10.2.0.0/16"
}

variable "pub_a_prod" {
  description = "subnet"
  type        = string
  default     = "10.2.5.0/24"
}


variable "pub_b_prod" {
  description = "subnet"
  type        = string
  default     = "10.2.6.0/24"
}

variable "pvt_a_prod" {
  description = "subnet"
  type        = string
  default     = "10.2.7.0/24"
}

variable "pvt_b_prod" {
  description = "subnet"
  type        = string
  default     = "10.2.8.0/24"
}



variable "jnlp_port" {
  description = "The port to use for TCP traffic between Jenkins intances"
  type        = number
  default     = 49187
}


variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections to Jenkins"
  type        = string
  default     = "0.0.0.0/0"
}


#################
# Peering Connection
#################

variable "peer_cidr_block_dev" {
  description = "Peer connection to dev"
  type        = string
  default     = "10.1.0.0/16"
}

variable "peer_cidr_block_prod" {
  description = "Peer connection to prod"
  type        = string
  default     = "10.2.0.0/16"
}



#################
# User Data
#################

variable "udata_jmaster" {
  description = "User Data to use for Jenkins master"
  type        = string
  default     = "./jmaster_setup.sh"
}

variable "udata_jslave" {
  description = "User Data to use for Jenkins master"
  type        = string
  default     = "./jslave_setup.sh"
}

variable "udata_dev" {
  description = "Name to be used for the Jenkins master instance"
  type        = string
  default     = "./dev_setup.sh"
}

variable "udata_prod" {
  description = "Name to be used for the dev web app"
  type        = string
  default     = "./prod_setup.sh"
}

variable "udata_asg_dev" {
  description = "Name to be used for the Jenkins master instance"
  type        = string
  default     = "./dev_setup.sh"
}

variable "udata_asg_prod" {
  description = "Name to be used for the Jenkins master instance"
  type        = string
  default     = "./prod_setup.sh"
}

#################
# Route 53
#################

variable "domain_name" {
  description = "domain_name"
  type        = string
  default     = "vieskovtf.com"
}

/*variable "zone_name" {
  description = "Route 53 zone name"
  type        = string  
}

variable "zone_id" {
  description = "Route 53 zone id"
  type        = string  
}*/

variable "create_certificate_dev" {
  description = "Create ACM certificate"
  type        = bool
  default     = false
}

variable "wait_for_validation_dev" {
  description = "Validation ACM certificate"
  type        = bool
  default     = true
}

variable "create_certificate_prod" {
  description = "Create ACM certificate"
  type        = bool
  default     = false
}

variable "wait_for_validation_prod" {
  description = "Validation ACM certificate"
  type        = bool
  default     = true
}



#################
# Database
#################

## prod ##

variable "db_identifier_dev" {
  description = "Database name"
  type        = string
  default     = "webdb"
}


variable "db_engine_dev" {
  description = "Database engine"
  type        = string
  default     ="postgres"
}

variable "db_engine_version_dev" {
  description = "Database engine version"
  type        = string
  default     ="11.10"
}

variable "db_family_dev" {
  description = "Database family"
  type        = string
  default    = "postgres11"
}

variable "db_major_engine_version_dev" {
  description = "Database major engine version"
  type        = string
  default    = "11" 
}

variable "db_instance_class_dev" {
  description = "Database instance class"
  type        = string
  default    =  "db.t3.large"  
}

variable "db_allocated_storage_dev" {
  description = "Database allocated storage"
  type        = number
  default    =   20                    
}

variable "db_max_allocated_storage_dev" {
  description = "Database max allocated storage"
  type        = number
  default    =   100                    
}

variable "db_storage_encrypted_dev" {
  description = "Database storage encrypted"
  type        = bool
  default    =   false                    
}

variable "db_name_dev" {
  description = "Database name"
  type        =  string
  default   =  "completePostgresql"
}


variable "db_username_dev" {
  description = "Database username"
  type        =  string
  default   = "complete_postgresql"
}

variable "db_password_dev" {
  description = "Database password"
  type        =  string
  default   = "YourPwdShouldBeLongAndSecure!"
}

variable "db_port_dev" {
  description = "Database port"
  type        = number
  default    =   5432                    
}

variable "db_multi_az_dev" {
  description = "Database multi available zone"
  type        = bool
  default    =   true                    
}

variable "db_maintenance_window_dev" {
  description = "Database username"
  type        =  string
  default   = "Mon:00:00-Mon:03:00"
}

variable "db_backup_window_dev" {
  description = "Database username"
  type        =  string
  default   = "03:00-06:00"
}

variable "db_enabled_cloudwatch_logs_exports_dev" {
  description = "Database enabled cloudwatch logs exports"
  type        =  list
  default   = ["postgresql", "upgrade"]
}

variable "db_backup_retention_period_dev" {
  description = "Database backup retention period"
  type        = number
  default    =   0                   
}

variable "db_skip_final_snapshot_dev" {
  description = "Database skip final snapshot"
  type        = bool
  default    =   true                    
}

variable "db_deletion_protection_dev" {
  description = "Database deletion protection"
  type        = bool
  default    =   false                    
}

variable "db_performance_insights_enabled_dev" {
  description = "Database  performance insights enabled"
  type        = bool
  default    =   true                   
}

variable "db_performance_insights_retention_period_dev" {
  description = "Database performance insights retention period"
  type        = number
  default    =   7                   
}

variable "db_create_monitoring_role_dev" {
  description = "Database deletion protection"
  type        = bool
  default    =   true                    
}

variable "db_monitoring_interval_dev" {
  description = "Database monitoring interval "
  type        = number
  default    =   60                   
}

variable "db_monitoring_role_name_dev" {
  description = "Database monitoring role name"
  type        =  string
  default   ="example-monitoring-role-name"
}

variable "db_monitoring_role_description_dev" {
  description = "monitoring_role_description"
  type        =  string
  default   = "Description for monitoring role"
}

## prod ##


variable "db_identifier_prod" {
  description = "Database name"
  type        = string
  default     = "webdb"
}


variable "db_engine_prod" {
  description = "Database engine"
  type        = string
  default     ="postgres"
}

variable "db_engine_version_prod" {
  description = "Database engine version"
  type        = string
  default     ="11.10"
}

variable "db_family_prod" {
  description = "Database family"
  type        = string
  default    = "postgres11"
}

variable "db_major_engine_version_prod" {
  description = "Database major engine version"
  type        = string
  default    = "11" 
}

variable "db_instance_class_prod" {
  description = "Database instance class"
  type        = string
  default    =  "db.t3.large"  
}

variable "db_allocated_storage_prod" {
  description = "Database allocated storage"
  type        = number
  default    =   20                    
}

variable "db_max_allocated_storage_prod" {
  description = "Database max allocated storage"
  type        = number
  default    =   100                    
}

variable "db_storage_encrypted_prod" {
  description = "Database storage encrypted"
  type        = bool
  default    =   false                    
}

variable "db_name_prod" {
  description = "Database name"
  type        =  string
  default   =  "completePostgresql"
}

variable "db_username_prod" {
  description = "Database username"
  type        =  string
  default   = "complete_postgresql"
}

variable "db_password_prod" {
  description = "Database password"
  type        =  string
  default   = "YourPwdShouldBeLongAndSecure!"
}

variable "db_port_prod" {
  description = "Database port"
  type        = number
  default    =   5432                    
}

variable "db_multi_az_prod" {
  description = "Database multi available zone"
  type        = bool
  default    =   true                    
}

variable "db_maintenance_window_prod" {
  description = "Database username"
  type        =  string
  default   = "Mon:00:00-Mon:03:00"
}

variable "db_backup_window_prod" {
  description = "Database username"
  type        =  string
  default   = "03:00-06:00"
}

variable "db_enabled_cloudwatch_logs_exports_prod" {
  description = "Database enabled cloudwatch logs exports"
  type        =  list
  default   = ["postgresql", "upgrade"]
}

variable "db_backup_retention_period_prod" {
  description = "Database backup retention period"
  type        = number
  default    =   0                   
}

variable "db_skip_final_snapshot_prod" {
  description = "Database skip final snapshot"
  type        = bool
  default    =   true                    
}

variable "db_deletion_protection_prod" {
  description = "Database deletion protection"
  type        = bool
  default    =   false                    
}

variable "db_performance_insights_enabled_prod" {
  description = "Database  performance insights enabled"
  type        = bool
  default    =   true                   
}

variable "db_performance_insights_retention_period_prod" {
  description = "Database performance insights retention period"
  type        = number
  default    =   7                   
}

variable "db_create_monitoring_role_prod" {
  description = "Database deletion protection"
  type        = bool
  default    =   true                    
}

variable "db_monitoring_interval_prod" {
  description = "Database monitoring interval "
  type        = number
  default    =   60                   
}

variable "db_monitoring_role_name_prod" {
  description = "Database monitoring role name"
  type        =  string
  default   ="example-monitoring-role-name"
}

variable "db_monitoring_role_description_prod" {
  description = "monitoring_role_description"
  type        =  string
  default   = "Description for monitoring role"
}







































