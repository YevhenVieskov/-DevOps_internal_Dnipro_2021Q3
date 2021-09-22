
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
  default     = "dev"
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
  default = "192.168.0.0/16"
}

variable "pub_a_dev" {
  description = "subnet"
  type        = string
  default     = "192.168.1.0/24"
}


variable "pub_b_dev" {
  description = "subnet"
  type        = string
  default     = "192.168.2.0/24"
}

variable "pvt_a_dev" {
  description = "subnet"
  type        = string
  default     = "192.168.3.0/24"
}

variable "pvt_b_dev" {
  description = "subnet"
  type        = string
  default     = "192.168.4.0/24"
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
  default = "192.168.10.0/16"
}

variable "pub_a_prod" {
  description = "subnet"
  type        = string
  default     = "192.168.11.0/24"
}


variable "pub_b_prod" {
  description = "subnet"
  type        = string
  default     = "192.168.12.0/24"
}

variable "pvt_a_prod" {
  description = "subnet"
  type        = string
  default     = "192.168.13.0/24"
}

variable "pvt_b_prod" {
  description = "subnet"
  type        = string
  default     = "192.168.14.0/24"
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
  description = "Peer connection to dev"
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





































