
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

 variable "db_port" {
  description = "The port used for SSH connections"
  type        = number
  default     = 3306
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










