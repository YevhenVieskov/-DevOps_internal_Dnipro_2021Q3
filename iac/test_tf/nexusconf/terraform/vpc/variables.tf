//Global variables
/*variable "region" {
  description = "AWS region"
}

variable "shared_credentials_file" {
  description = "AWS credentials file path"
}

variable "aws_profile" {
  description = "AWS profile"
}*/

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

variable "hosted_zone_id" {
  description = "Route53 zone id"
}

variable "bastion_key_name" {
  description = "Bastion KeyName"
}

variable "availability_zones" {
  type        = list
  description = "List of Availability Zones"
}

// Default variables
variable "vpc_name" {
  description = "VPC name"
  default     = "nexus-user-conference"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "public_count" {
  default     = 2
  description = "Number of public subnets"
}

variable "private_count" {
  default     = 2
  description = "Number of private subnets"
}

variable "bastion_instance_type" {
  description = "Bastion Instance type"
  default     = "t2.micro"
}
