
#################
# Credentials
#################
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

variable "availability_zone" {
  description = "Region for AWS resources"
  type        = string
  default     = "us-east-2b"
}

#################
# Environment
#################

variable "env" {
  description = "Environment tag"
  type        = string
  default     = "jenkins"
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




#################
# Instance type
#################

variable "instance_type" {
  description = "Instance Type to use for Jenkins master"
  type        = string
  default     = "t2.micro"
}

#################
# Network
#################

variable "vpc_cidr_jenkins" {
  type        = string
  default = "10.0.0.0/16"
}


variable "pub_a" {
  description = "subnet"
  type        = string
  default     = "10.0.1.0/24"
}


variable "pub_b" {
  description = "subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "pvt_a" {
  description = "subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "pvt_b" {
  description = "subnet"
  type        = string
  default     = "10.0.4.0/24"
}


variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = "vieskovtf"
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
# User Data
#################

variable "udata_jmaster" {
  description = "User Data to use for Jenkins master"
  type        = string
  default     = "./ec2_setup.sh"
}

variable "udata_jslave" {
  description = "User Data to use for Jenkins master"
  type        = string
  default     = "./ec2_setup.sh"
}




































