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

variable "name" {
  description = "Name to be used for the Jenkins master instance"
  type        = string
  default     = "jenkins-master"
}

variable "environment" {
  description = "The environement tag to add to Jenkins master instance"
  type        = string  
  default     = "dev"
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
/*variable "ami_id" {
  description = "The ID of the AMI to run in this Jenkins master instance"
  type        = string
}*/

/*


variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default = ""
}

variable "subnet_ids" {
  description = "Subnets for the load balancer listener to use"
  type = list
}

variable "aws_ssl_certificate_arn" {
  description = "Amazon Resource Name for the certificate to be used on the load balancer for HTTPS"
  type        = string
}

variable "dns_zone" {
  description = "DNS zone in AWS Route53 to use with the ALB"
}

variable "app_dns_name" {
  description = "DNS name within the zone to dynamically point to the ALB"
  type        = string
}

variable "alb_prefix" {
  description = "Naming prefix for ALB-related resources"
  type        = string
}

variable "user_data" {
  description = "A User Data script to execute while the server is booting."
  type        = string
}

variable "setup_data" {
  description = "A User Data script to execute after server has booted to setup jenkins defaults."
  type        = string
}



variable "ssh_key_path" {
  description = "The path of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Used for provisioning."
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections on SSH"
  type        = list
}

variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections to Jenkins"
  type        = list
}

variable "ssh_port" {
  description = "The port used for SSH connections"
  type        = number
  default     = 22
}

variable "http_port" {
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

variable "tags" {
  type = map
  description = "Supply tags you want added to all resources"
  default = {
  }
}*/