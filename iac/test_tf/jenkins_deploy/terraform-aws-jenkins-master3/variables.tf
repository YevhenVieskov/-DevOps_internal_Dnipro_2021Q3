# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# APPLICATION LOAD BALANCER CONFIGURATION
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_ssl_certificate_arn" {
  description = "Amazon Resource Name for the certificate to be used on the load balancer for HTTPS"
}

variable "dns_zone" {
  description = "DNS zone in AWS Route53 to use with the ALB"
}

variable "app_dns_name" {
  description = "DNS name within the zone to dynamically point to the ALB"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "Name to be used on all instances as prefix"
  type        = string
  default     = ""
}

variable "win_slave_count" {
  description = "Number of windows slave instances to launch"
  type        = number
  default     = 0
}

variable "linux_slave_count" {
  description = "Number of linux slave instances to launch"
  type        = number
  default     = 1
}

variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  type        = string
  default     = "us-east-2"
}

variable "master_ami_id" {
  description = "ID of AMI to use for master instance(s)"
  type        = string
  default     = ""
}

variable "linux_slave_ami_id" {
  description = "ID of AMI to use for linux slave instance(s)"
  type        = string
  default     = ""
}

variable "win_slave_ami_id" {
  description = "ID of AMI to use for windows slave instance(s)"
  type        = string
  default     = ""
}

variable "instance_type_master" {
  description = "Instance Type to use for master instance(s)"  
  type        = string
  default     = "t2.micro"
}

variable "http_port" {
  description = "The port to use for HTTP traffic to Jenkins"
  type        = number
  default     = 8080
}

variable "jnlp_port" {
  description = "The Port to use for Jenkins master to slave communication bewtween instances"
  type        = number
  default     = 49187
}

variable "instance_type_slave" {
  description = "Instance Type to use for slave instance(s)"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = ""
}

variable "ssh_key_path" {
  description = "The path of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Used for provisioning."
  type        = string
  default     = ""
}

variable "plugins" {
  type        = list
  description = "A list of Jenkins plugins to install, use short names."
  default     = ["git", "xunit"]
}

variable "tags" {
  type = map
  description = "Supply tags you want added to all resources"
  default = {
  }
}